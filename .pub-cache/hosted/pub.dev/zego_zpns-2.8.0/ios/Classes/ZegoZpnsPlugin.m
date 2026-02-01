#import "ZegoZpnsPlugin.h"
#import <ZPNs/ZPNs.h>
#import "internal/utils/NSDictionary+safeInvoke.h"
#import "ZPNsSettings.h"
#import "ZPNsEventManager.h"
#import "ZPNsMethodManager.h"
#import "internal/utils/NSMutableDictionary+safeInvoke.h"
#import "internal/utils/ZPNsUtils.h"
@interface ZegoZpnsPlugin ()<ZPNsNotificationCenterDelegate>

@property FlutterMethodChannel *methodChannel;

@property (nonatomic, strong) FlutterEventChannel *eventChannel;



@end

@implementation ZegoZpnsPlugin {
    API_AVAILABLE(ios(10), macosx(10.14))
    __weak id<UNUserNotificationCenterDelegate> _originalNotificationCenterDelegate;
    API_AVAILABLE(ios(10), macosx(10.14))
    struct {
      unsigned int willPresentNotification : 1;
      unsigned int didReceiveNotificationResponse : 1;
      unsigned int openSettingsForNotification : 1;
    } _originalNotificationCenterDelegateRespondsTo;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel
      methodChannelWithName:@"zego_zpns"
            binaryMessenger:[registrar messenger]];
  ZegoZpnsPlugin* instance = [[ZegoZpnsPlugin alloc] init];
  [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:methodChannel];
  [[ZPNs shared] setZPNsNotificationCenterDelegate:(id)[ZPNsEventManager sharedInstance]];
  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"zpns_event_handler" binaryMessenger:[registrar messenger]];
  [eventChannel setStreamHandler:(id)instance];
  instance.methodChannel = methodChannel;
  instance.eventChannel = eventChannel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Application
        // Dart -> `getInitialNotification`
        // ObjC -> Initialize other delegates & observers
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(application_onDidFinishLaunchingNotification:)
#if TARGET_OS_OSX
                   name:NSApplicationDidFinishLaunchingNotification
#else
                   name:UIApplicationDidFinishLaunchingNotification
#endif
                 object:nil];
    }
      return self;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    [ZPNsSettings setEvent:events];
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:result:", call.method]);
    
    if (![[ZPNsMethodManager sharedInstance] respondsToSelector:selector]) {
        result(FlutterMethodNotImplemented);
        return;
    }
    NSMethodSignature *signature = [[ZPNsMethodManager sharedInstance] methodSignatureForSelector:selector];

    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];

    invocation.target = [ZPNsMethodManager sharedInstance];
    invocation.selector = selector;

    [invocation setArgument:&call atIndex:2];
    [invocation setArgument:&result atIndex:3];

    [invocation invoke];
}

#pragma mark - Observe App
- (void)application_onDidFinishLaunchingNotification:(nonnull NSNotification *)notification {
  // Setup UIApplicationDelegate.
    NSDictionary *remoteNotification =
        notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification != nil) {
        [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"get init notification: %@", remoteNotification]];
    }

  // Set UNUserNotificationCenter but preserve original delegate if necessary.
  if (@available(iOS 10.0, macOS 10.14, *)) {
    BOOL shouldReplaceDelegate = YES;
    UNUserNotificationCenter *notificationCenter =
        [UNUserNotificationCenter currentNotificationCenter];

    if (notificationCenter.delegate != nil) {
#if !TARGET_OS_OSX
      if ([notificationCenter.delegate conformsToProtocol:@protocol(FlutterAppLifeCycleProvider)]) {
          // Note this one only executes if Firebase swizzling is **enabled**.
          shouldReplaceDelegate = NO;
          [ZPNsUtils wirteCustomLog:@"app delegate has set the UNUserNotificationCenterDelegate, so we ignore it"];
      }
#endif

      if (shouldReplaceDelegate) {
        _originalNotificationCenterDelegate = notificationCenter.delegate;
        _originalNotificationCenterDelegateRespondsTo.openSettingsForNotification =
            (unsigned int)[_originalNotificationCenterDelegate
                respondsToSelector:@selector(userNotificationCenter:openSettingsForNotification:)];
        _originalNotificationCenterDelegateRespondsTo.willPresentNotification =
            (unsigned int)[_originalNotificationCenterDelegate
                respondsToSelector:@selector(userNotificationCenter:
                                            willPresentNotification:withCompletionHandler:)];
        _originalNotificationCenterDelegateRespondsTo.didReceiveNotificationResponse =
            (unsigned int)[_originalNotificationCenterDelegate
                respondsToSelector:@selector(userNotificationCenter:
                                       didReceiveNotificationResponse:withCompletionHandler:)];
          
          [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"we should save the original delegate to call them. will present: %u, did response: %u, open settings: %u", _originalNotificationCenterDelegateRespondsTo.willPresentNotification, _originalNotificationCenterDelegateRespondsTo.didReceiveNotificationResponse, _originalNotificationCenterDelegateRespondsTo.openSettingsForNotification]];
      }
    }

    if (shouldReplaceDelegate) {
        __strong ZegoZpnsPlugin<UNUserNotificationCenterDelegate> *strongSelf = self;
        notificationCenter.delegate = strongSelf;
    }
  }

}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ZPNsUtils wirteCustomLog:@"application:didFinishLaunchingWithOptions"];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[ZPNs shared] setDeviceToken:deviceToken isProduct:!([ZPNsMethodManager sharedInstance].debug)];
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"application:didRegisterForRemoteNotificationsWithDeviceToken,set deveice token,device token:%@,isProduct:%@",[ZPNsUtils getHexStringForData:deviceToken],!([ZPNsMethodManager sharedInstance].debug)?@"true":@"false"]];
    NSLog(@"device token :%@",[ZPNsUtils getHexStringForData:deviceToken]);
}

- (void)application:(UIApplication*)application
didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    
    [[ZPNsEventManager sharedInstance] ZPNsRegisterFailed:error];
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"application:didFailToRegisterForRemoteNotificationsWithError,error code:%ld,error message:%@",(long)error.code,error.localizedDescription?error.localizedDescription:@""]];
}

- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler API_AVAILABLE(ios(7.0)){
    
   // [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"application:didReceiveRemoteNotification:fetchCompletionHandler. userInfo: %@", [ZPNsUtils getUserInfoJson:userInfo]]];
    // Only handle notifications from zego.
    if (userInfo[@"zego"]) {
      if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        __block BOOL completed = NO;
        
        // If app is in background state, register background task to guarantee async queues aren't
        // frozen.
        [ZPNsUtils wirteCustomLog:@"begin start background task and after timer for silent push"];
        UIBackgroundTaskIdentifier __block backgroundTaskId =
            [application beginBackgroundTaskWithExpirationHandler:^{
              @synchronized(self) {
                if (completed == NO) {
                  completed = YES;
                  [ZPNsUtils wirteCustomLog:@"background task expired"];
                  completionHandler(UIBackgroundFetchResultNewData);
                  if (backgroundTaskId != UIBackgroundTaskInvalid) {
                    [application endBackgroundTask:backgroundTaskId];
                    backgroundTaskId = UIBackgroundTaskInvalid;
                  }
                }
              }
            }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                         @synchronized(self) {
                           if (completed == NO) {
                             completed = YES;
                             [ZPNsUtils wirteCustomLog:@"after timer task expired"];
                             completionHandler(UIBackgroundFetchResultNewData);
                             if (backgroundTaskId != UIBackgroundTaskInvalid) {
                               [application endBackgroundTask:backgroundTaskId];
                               backgroundTaskId = UIBackgroundTaskInvalid;
                             }
                           }
                         }
                       });
        
        [self.methodChannel invokeMethod:@"onThroughBackgroundMessageForIOS"
                     arguments:userInfo
                        result:^(id _Nullable result) {
                          FlutterError *error = result;
                          [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"invoke background method result. error code: %@, msg: %@, detail: %@", error.code, error.message, error.details]];
                          @synchronized(self) {
                            if (completed == NO) {
                              completed = YES;
                              [ZPNsUtils wirteCustomLog:@"on through background message handle done"];
                              completionHandler(UIBackgroundFetchResultNewData);
                              if (backgroundTaskId != UIBackgroundTaskInvalid) {
                                [application endBackgroundTask:backgroundTaskId];
                                backgroundTaskId = UIBackgroundTaskInvalid;
                              }
                            }
                          }
                        }];
      } else {
        // If "alert" (i.e. notification) is present in userInfo, this will be called by
        // "onNotificationArrived"
        if(userInfo[@"aps"] != nil && userInfo[@"aps"][@"alert"] == nil) {
            [[ZPNsEventManager sharedInstance] ZPNsDidReceiveNotificationFromForeground:userInfo];
        }
        completionHandler(UIBackgroundFetchResultNoData);
      }

      return YES;
    }  // if (userInfo[@"zego"])
    return NO;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:
             (void (^)(UNNotificationPresentationOptions options))completionHandler
    API_AVAILABLE(macos(10.14), ios(10.0)) {
    
    if(notification.request.content.userInfo[@"zego"]) {
        [[ZPNsEventManager sharedInstance] ZPNsNotificationCenter:center willPresentNotification:notification userInfo:notification.request.content.userInfo withCompletionHandler:completionHandler];
    }

    // Forward on to any other delegates amd allow them to control presentation behavior.
    if (_originalNotificationCenterDelegate != nil &&
        _originalNotificationCenterDelegateRespondsTo.willPresentNotification) {
        [_originalNotificationCenterDelegate userNotificationCenter:center
                                            willPresentNotification:notification
                                              withCompletionHandler:completionHandler];
    } else {
        UNNotificationPresentationOptions presentationOptions = UNNotificationPresentationOptionNone;
        if(ZPNsSettings.isPresentBadge) {
            presentationOptions |= UNNotificationPresentationOptionBadge;
        }
        
        if(ZPNsSettings.isPresentSound) {
            presentationOptions |= UNNotificationPresentationOptionSound;
        }
        
        if(ZPNsSettings.isPresentAlert) {
            presentationOptions |= UNNotificationPresentationOptionAlert;
        }
      
        completionHandler(presentationOptions);
    }
    
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"onUserNotificationCenterWillPresentNotification. userInfo: %@", notification.request.content.userInfo]];
}

// Called when a user interacts with a notification.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler
    API_AVAILABLE(macos(10.14), ios(10.0)) {
      
    if(response.notification.request.content.userInfo[@"zego"]) {
        [[ZPNsEventManager sharedInstance] ZPNsNotificationCenter:center didReceiveNotificationResponse:response userInfo:response.notification.request.content.userInfo withCompletionHandler:completionHandler];
    }

    // Forward on to any other delegates.
    if (_originalNotificationCenterDelegate != nil &&
      _originalNotificationCenterDelegateRespondsTo.didReceiveNotificationResponse) {
        [_originalNotificationCenterDelegate userNotificationCenter:center
                                     didReceiveNotificationResponse:response
                                              withCompletionHandler:completionHandler];
    } else {
        completionHandler();
    }
    
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"onUserNotificationCenterDidReceiveNotificationResponse. userInfo: %@", response.notification.request.content.userInfo]];
}

// We don't use this for ZPNs, but for the purpose of forwarding to any original delegates we
// implement this.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    openSettingsForNotification:(nullable UNNotification *)notification
    API_AVAILABLE(macos(10.14), ios(10.0)) {
  // Forward on to any other delegates.
  if (_originalNotificationCenterDelegate != nil &&
      _originalNotificationCenterDelegateRespondsTo.openSettingsForNotification) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
    [_originalNotificationCenterDelegate userNotificationCenter:center
                                    openSettingsForNotification:notification];
#pragma clang diagnostic pop
  }
}
@end
