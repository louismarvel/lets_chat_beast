#import "ZegoCallkitPlugin.h"
#import "internal/ZegoCallkitSettings.h"
#import "internal/ZegoCallkitMethodHandler.h"
#import "internal/ZegoCallkitEventHandler.h"

@implementation ZegoCallkitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_callkit"
            binaryMessenger:[registrar messenger]];
  ZegoCallkitPlugin* instance = [[ZegoCallkitPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  
  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"zego_callkit_event_handler" binaryMessenger:[registrar messenger]];
  [eventChannel setStreamHandler:(id)instance];
    
  [ZegoCallkitPlugin registerVoIPToken];
}

+ (void)registerVoIPToken{
    if(![ZegoCallkitSettings sharedInstance].cxProviderConfiguration){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *callKitInitConfigDic = [userDefault objectForKey:@"zegoCallKitInitConfig"];
        if(!(callKitInitConfigDic == nil || callKitInitConfigDic == NULL || [callKitInitConfigDic isEqual:[NSNull null]])){
            [[ZegoCallkitMethodHandler sharedInstance] setInitConfig:callKitInitConfigDic];
        }else{
            callKitInitConfigDic = @{@"localizedName":@"Undefined"};
            [[ZegoCallkitMethodHandler sharedInstance] setInitConfig:callKitInitConfigDic];
        }
    }
        
    if([ZegoCallkitSettings sharedInstance].pkPushRegistry == nil){
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        [[ZegoCallkitSettings sharedInstance] setPkPushRegistry:[[PKPushRegistry alloc] initWithQueue:mainQueue]];
        [[ZegoCallkitSettings sharedInstance].pkPushRegistry setDelegate:[ZegoCallkitEventHandler sharedInstance]];
        NSMutableSet *desiredPushTypes = [[NSMutableSet alloc] init];
        [desiredPushTypes addObject:PKPushTypeVoIP];
        [ZegoCallkitSettings sharedInstance].pkPushRegistry.desiredPushTypes = desiredPushTypes;
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:result:", call.method]);

    if (![[ZegoCallkitMethodHandler sharedInstance] respondsToSelector:selector]) {
        result(FlutterMethodNotImplemented);
        return;
    }
    NSMethodSignature *signature = [[ZegoCallkitMethodHandler sharedInstance] methodSignatureForSelector:selector];

    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];

    invocation.target = [ZegoCallkitMethodHandler sharedInstance];
    invocation.selector = selector;

    [invocation setArgument:&call atIndex:2];
    [invocation setArgument:&result atIndex:3];

    [invocation invoke];
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    [[ZegoCallkitSettings sharedInstance] setEvent:events];
    [[ZegoCallkitMethodHandler sharedInstance] isSetEvent:YES];
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    [[ZegoCallkitSettings sharedInstance] setEvent:nil];
    [[ZegoCallkitMethodHandler sharedInstance] isSetEvent:NO];
    return nil;
}

@end
