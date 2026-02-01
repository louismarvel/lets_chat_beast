//
//  ZPNsEventManager.m
//  zego_zpns
//
//  Created by 武耀琳 on 2023/3/6.
//

#import "ZPNsEventManager.h"
#import <ZPNs/ZPNs.h>
#import "utils/NSMutableDictionary+safeInvoke.h"
#import "ZPNsSettings.h"
#import "ZPNsUtils.h"
@interface ZPNsEventManager()<ZPNsNotificationCenterDelegate>

@property bool debug;

@end

@implementation ZPNsEventManager


+ (instancetype)sharedInstance {
    static ZPNsEventManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZPNsEventManager alloc] init];
    });
    return instance;
}


#pragma mark - ZPNsNotificationCenterDelegate

- (void)onRegistered:(NSString *)Pushid{
    if(ZPNsSettings.event == nil){
        [ZPNsUtils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] onRegistered."]];
        return;
    }
    NSDictionary *resultDic = @{@"method":@"onRegistered",@"message":@{@"pushID":Pushid,@"errorCode":[NSNumber numberWithInt:0],@"pushSourceType":[NSNumber numberWithInt:10],@"msg":@"",@"commandResult":@""}};
    ZPNsSettings.event(resultDic);
}

- (void)ZPNsRegisterFailed:(NSError *)error {
    if(ZPNsSettings.event == nil){
        return;
    }
    NSDictionary *resultDic = @{@"method":@"onRegistered",@"message":@{@"pushID":@"",@"errorCode":[NSNumber numberWithInteger:error.code],@"pushSourceType":[NSNumber numberWithInt:10],@"msg":error.localizedDescription?error.localizedDescription:@"",@"commandResult":@""}};
    ZPNsSettings.event(resultDic);
}

- (void)ZPNsDidReceiveNotificationFromForeground:(NSDictionary *)userInfo {
    if(ZPNsSettings.event == nil){
        return;
    }
    
    NSDictionary *resultDic = @{@"method":@"onThroughMessageReceived", @"userInfo":userInfo};
    ZPNsSettings.event(resultDic);
}

- (void)ZPNsNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
                      userInfo:(NSDictionary *)userInfo
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(macos(10.14), ios(10.0)){
    if(ZPNsSettings.event == nil){
        return;
    }
    NSMutableDictionary *messageMap = [[NSMutableDictionary alloc] init];
    [messageMap safeSetObject:notification.request.content.title forKey:@"title"];
    [messageMap safeSetObject:notification.request.content.body forKey:@"content"];
    [messageMap safeSetObject:userInfo forKey:@"extras"];
    [messageMap safeSetObject:[NSNumber numberWithInt:10] forKey:@"pushSourceType"];
    
    NSDictionary *resultDic = @{@"method":@"onNotificationArrived",@"message":messageMap};
    [ZPNsUtils
          wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] onNotificationArrived:%@",resultDic]];
    ZPNsSettings.event(resultDic);
}

- (void)ZPNsNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
                          userInfo:(NSDictionary *)userInfo
         withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(macos(10.14), ios(10.0)){
    NSMutableDictionary *messageMap = [[NSMutableDictionary alloc] init];
    NSString *payload = @"";
    if(userInfo != nil){
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        if(aps != nil){
            payload = [aps objectForKey:@"payload"];
        }
    }
    [messageMap safeSetObject:response.notification.request.content.title forKey:@"title"];
    [messageMap safeSetObject:response.notification.request.content.body forKey:@"content"];
    [messageMap safeSetObject:payload forKey:@"payload"];
    [messageMap safeSetObject:userInfo forKey:@"extras"];
    [messageMap safeSetObject:[NSNumber numberWithInt:10] forKey:@"pushSourceType"];
    
    NSDictionary *resultDic = @{@"method":@"onNotificationClicked",@"message":messageMap};
    if(ZPNsSettings.isRegisterPushInvoked == false){
        [ZPNsSettings setHoldClickedResultMap:resultDic];
        return;
    }
    if(ZPNsSettings.event == nil){
        return;
    }
    [ZPNsUtils
          wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] onNotificationClicked:%@",resultDic]];
    ZPNsSettings.event(resultDic);
}

@end
