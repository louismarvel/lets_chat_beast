//
//  ZPNsMethodManager.m
//  zego_zpns
//
//  Created by 武耀琳 on 2023/3/6.
//

#import "ZPNsMethodManager.h"
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import "utils/NSDictionary+safeInvoke.h"
#import "utils/NSMutableDictionary+safeInvoke.h"
#import "ZPNsSettings.h"
#import <ZPNs/ZPNs.h>
#import "ZPNsConverter.h"
#import "utils/ZPNsUtils.h"
@interface ZPNsMethodManager ()<ZPNsNotificationCenterDelegate>

@property(nonatomic,assign) unsigned long long localDefaultNotificationIdSequence;

@end

@implementation ZPNsMethodManager

+ (instancetype)sharedInstance {
    static ZPNsMethodManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZPNsMethodManager alloc] init];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSNumber *localNotificationIdSequenceNumber = [userDefault objectForKey:@"zegoLocalNotificationIdSequence"];
        if([ZPNsUtils isNotNull:localNotificationIdSequenceNumber]){
            instance.localDefaultNotificationIdSequence = [localNotificationIdSequenceNumber unsignedLongLongValue];
        }
    });
    return instance;
}


-(void)getPlatformVersion:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
}

-(void)getVersion:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([ZPNs getVersion]);
}

-(void)applyNotificationPermission:(FlutterMethodCall *)call result:(FlutterResult)result {
    [ZPNsUtils
          wirteCustomLog:[NSString stringWithFormat:@"[API] applyNotificationPermission."]];
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                [ZPNsUtils
                      wirteCustomLog:[NSString stringWithFormat:@"The user has allowed the app to send push notifications."]];
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    
                }];
                
            } else {
                [ZPNsUtils
                      wirteCustomLog:[NSString stringWithFormat:@"The user not allowed the app to send push notifications."]];
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else {
        // Fallback on earlier versions
        
    }
    result(nil);
}

-(void)enableDebug:(FlutterMethodCall *)call result:(FlutterResult)result {
    self.debug = [[call.arguments objectForKey:@"debug"] boolValue];
    result(nil);
}

-(void)automaticDetection:(FlutterMethodCall *)call result:(FlutterResult)result {
    self.debug = [ZPNsUtils isSandboxApp];
    result(nil);
}

-(void)getPushConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    result(nil);
}

-(void)setPushConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *configDic = [call.arguments safeObjectForKey:@"config"];
    [ZPNsUtils
          wirteCustomLog:[NSString stringWithFormat:@"[API] setPushConfig:%@",configDic]];
    ZPNsConfig *config = [ZPNsConverter oZPNsPushConfig:configDic];
    [[ZPNs shared] setPushConfig:config];
    result(nil);
}

-(void)registerPush:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *extendedData = [call.arguments safeObjectForKey:@"extendedData"];
    [[ZPNs shared] registerAPNs];
    bool enableIOSVoIP = [extendedData safeObjectForKey:@"enableIosVoIP"];
    if(enableIOSVoIP){
        Class ZegoCallkitMethodHandler = NSClassFromString(@"ZegoCallkitMethodHandler");
        if(ZegoCallkitMethodHandler == nil){
  //          result([FlutterError errorWithCode:[NSString stringWithFormat:@"1"] message:[NSString stringWithFormat:@"You entered the enableVoIP bool parameter in registerPush, but did not inherit the ZegoCallKit library"] details:nil]);
            return;
        }
        id zegoCallkitMehtodHandlerInstance = [ZegoCallkitMethodHandler valueForKey:@"sharedInstance"];
        if(zegoCallkitMehtodHandlerInstance == nil){
  //          [ZPNsUtils wirteCustomLog:@"ZegoCallkitMethodHandler did not find the method named sharedInstance."];
            return;
        }
        SEL selector = NSSelectorFromString(@"enableVoIP:");
        NSMethodSignature *methodSignature = [ZegoCallkitMethodHandler instanceMethodSignatureForSelector:selector];
        if(methodSignature){
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setTarget:zegoCallkitMehtodHandlerInstance];
            NSNumber *isProductNumber = [NSNumber numberWithBool:!self.debug];
            [invocation setArgument:&isProductNumber atIndex:2];
            [invocation invoke];
        }
    }
    
    bool isPresentBadge = [extendedData safeObjectForKey:@"iOSPresentBadge"];
    bool isPresentSound = [extendedData safeObjectForKey:@"iOSPresentSound"];
    bool isPresentAlert = [extendedData safeObjectForKey:@"iOSPresentAlert"];
    [ZPNsSettings setIsPresentBadge:isPresentBadge];
    [ZPNsSettings setIsPresentSound:isPresentSound];
    [ZPNsSettings setIsPresentAlert:isPresentAlert];
    
    [ZPNsSettings setIsRegisterPushInvoked:true];
    if(ZPNsSettings.holdClickedResultMap != nil){
        ZPNsSettings.event(ZPNsSettings.holdClickedResultMap);
        [ZPNsSettings clearHoldClickedResultMap];
    }
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"[API] registerPush, enable voip:%@",enableIOSVoIP?@"true":@"false"]];
    result(nil);
}

-(void)unregisterPush:(FlutterMethodCall *)call result:(FlutterResult)result {
    [[ZPNs shared] unregisterAPNs];
    [ZPNsUtils wirteCustomLog:@"[API] unregisterPush"];
    
    result(nil);
}

-(void)addLocalNotification:(FlutterMethodCall *)call result:(FlutterResult)result {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    NSDictionary *localMessageDic = [call.arguments safeObjectForKey:@"message"];
    content.title = [localMessageDic safeObjectForKey:@"title"];
    content.body = [localMessageDic safeObjectForKey:@"content"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo safeSetObject:[localMessageDic safeObjectForKey:@"payload"] forKey:@"payload"];
    
    unsigned long long recentSeq = ++_localDefaultNotificationIdSequence;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithUnsignedLongLong:recentSeq] forKey:@"zegoLocalNotificationIdSequence"];
    NSString *localZPNsRequestID = [NSString stringWithFormat:@"zego#%lld",recentSeq];
    
    NSMutableDictionary *localZegoInfo = [NSMutableDictionary dictionary];
    [localZegoInfo safeSetObject:localZPNsRequestID forKey:@"local_zpns_request_id"];
    [userInfo safeSetObject:localZegoInfo forKey:@"zego"];
    
    content.userInfo = userInfo;
    
    NSString *sound = [localMessageDic safeObjectForKey:@"iOSSound"];
    if(sound != nil && ![sound isEqual:@""]){
        content.sound = [UNNotificationSound soundNamed:sound];
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
    if (@available(iOS 15.0, *)) {
        content.interruptionLevel = UNNotificationInterruptionLevelActive;
    }
#endif
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:localZPNsRequestID content:content trigger:nil];
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"[API] addLocalNotify,id:%@",localZPNsRequestID]];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"addLocalNotify complete,id:%@,error:%@",[NSString stringWithFormat:@"zego#%lld",recentSeq],error]];
    }];
    result(nil);
}

-(void)createNotificationChannel:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(nil);
}

-(void)setLocalBadge:(FlutterMethodCall *)call result:(FlutterResult)result {
    int badge = [[call.arguments objectForKey:@"badge"] intValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    result(nil);
}

-(void)setServerBadge:(FlutterMethodCall *)call result:(FlutterResult)result {
    int badge = [[call.arguments objectForKey:@"badge"] intValue];
    [[ZPNs shared] setBadge:badge];
    result(nil);
}

/*-(void)didReceiveRemoteNotificationCompletion:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *seq = [call.arguments safeObjectForKey:@"seq"];
    NSNumber *fetchResult= [call.arguments safeObjectForKey:@"result"];
    id completion = [ZPNsSettings.didReceiveRemoteNotificationCompletionSeqMap safeObjectForKey:seq];
    ((void (^)(UIBackgroundFetchResult result))completion)([fetchResult unsignedIntegerValue]);
}*/

#pragma mark - utils
@end
