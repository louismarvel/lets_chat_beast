//
//  ZPNsSettings.m
//  zego_zpns
//
//  Created by 武耀琳 on 2023/3/6.
//

#import "ZPNsSettings.h"

static bool _isProduct = false;

static bool _isRegisterPushInvoked = false;

static FlutterEventSink _event = nil;

static FlutterMethodChannel *_methodChannel = nil;

//static NSMutableDictionary *_didReceiveRemoteNotificationCompletionSeqMap = nil;
static unsigned int _seq = 0;

static NSDictionary *_holdClickedResultMap = nil;

static BOOL _isPresentBadge = false;

static BOOL _isPresentSound = false;

static BOOL _isPresentAlert = false;

@implementation ZPNsSettings

+(bool)isProduct{
    return _isProduct;
}

+(void)setIsProduct:(bool)isProduct{
    _isProduct = isProduct;
}

+(FlutterEventSink)event{
    return _event;
}

+(void)setEvent:(FlutterEventSink)event{
    _event = event;
}

+ (FlutterMethodChannel *)methodChannel{
    return _methodChannel;
}

+(void)setHoldClickedResultMap:(NSDictionary *)holdClickedResultMap{
    _holdClickedResultMap = [[NSDictionary alloc] initWithDictionary:holdClickedResultMap];
}

+ (NSDictionary *)holdClickedResultMap{
    return _holdClickedResultMap;
}

+(void)clearHoldClickedResultMap{
    _holdClickedResultMap = nil;
}

+(void)setMethodChannel:(FlutterMethodChannel *)methodChannel{
    _methodChannel = methodChannel;
}

+(bool)isRegisterPushInvoked{
    return _isRegisterPushInvoked;
}

+(void)setIsRegisterPushInvoked:(bool)isRegisterPushInvoked{
    _isRegisterPushInvoked = isRegisterPushInvoked;
}

/*+ (void)setDidReceiveRemoteNotificationCompletionSeqMap:(NSMutableDictionary *)didReceiveRemoteNotificationCompletionSeqMap{
    
}

+ (NSMutableDictionary *)didReceiveRemoteNotificationCompletionSeqMap{
    if(_didReceiveRemoteNotificationCompletionSeqMap == nil){
        _didReceiveRemoteNotificationCompletionSeqMap = [[NSMutableDictionary alloc] init];
    }
    return _didReceiveRemoteNotificationCompletionSeqMap;
}*/

+(void)setIsPresentBadge:(BOOL)isPresentBadge {
    _isPresentBadge = isPresentBadge;
}

+(bool)isPresentBadge {
    return _isPresentBadge;
}

+(void)setIsPresentSound:(BOOL)isPresentSound {
    _isPresentSound = isPresentSound;
}

+(bool)isPresentSound {
    return _isPresentSound;
}

+(void)setIsPresentAlert:(BOOL)isPresentAlert {
    _isPresentAlert = isPresentAlert;
}

+(bool)isPresentAlert {
    return _isPresentAlert;
}

@end
