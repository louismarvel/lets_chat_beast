//
//  ZegoCallkitEventHandler.m
//  zego_callkit
//
//  Created by 武耀琳 on 2023/9/28.
//

#import "ZegoCallkitEventHandler.h"
#import "utils/NSDictionary+zegoCallkitSafeInvoke.h"
#import "utils/NSMutableDictionary+zegoCallkitSafeInvoke.h"
#import "utils/ZegoCallkitUtils.h"
#import "ZegoCallkitSettings.h"
#import "ZegoCallkitConverter.h"
@interface ZegoCallkitEventHandler()

@property(nonatomic,strong) ZegoCallkitSettings *settings;

@property(nonatomic,strong) ZegoCallkitUtils *utils;

@property(nonatomic,strong)ZegoCallkitConverter *converter;

@end

@implementation ZegoCallkitEventHandler


+(ZegoCallkitEventHandler *)sharedInstance{
    static ZegoCallkitEventHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.settings = [ZegoCallkitSettings sharedInstance];
        sharedInstance.utils = [ZegoCallkitUtils sharedInstance];
        sharedInstance.converter = [ZegoCallkitConverter sharedInstance];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - PKPushRegistryDelegate delegate

- (void)pushRegistry:(nonnull PKPushRegistry *)registry didUpdatePushCredentials:(nonnull PKPushCredentials *)pushCredentials forType:(nonnull PKPushType)type {
    NSString *voipToken = [_utils getHexStringForData:[pushCredentials token]];
    [_utils wirteCustomLog:[NSString stringWithFormat:@"setVoipToken, voip token:%@,isProduct:%@",voipToken,_settings.isProduct?@"true":@"false"]];
    NSData *voIPToken = [pushCredentials token];
    _settings.voIPToken = voIPToken;
    if(_settings.enableVoIP){
        Class ZPNs = NSClassFromString(@"ZPNs");
        if (ZPNs == nil) {
            return;
        }
        id zpns = [ZPNs valueForKey:@"shared"];
        if(zpns == nil){
            return;
        }
        SEL selector = NSSelectorFromString(@"setVoipToken:isProduct:");
        NSMethodSignature *methodSignature = [ZPNs instanceMethodSignatureForSelector:selector];
        if(methodSignature){
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setTarget:zpns];
            [invocation setArgument:&voIPToken atIndex:2];
            BOOL isProduct = _settings.isProduct;
            [invocation setArgument:&isProduct atIndex:3];
            [invocation invoke];
        }
    }
    NSLog(@"voip token %@",voipToken);
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion{
    [_utils
          wirteCustomLog:[NSString stringWithFormat:@"didReceiveIncomingPushWithPayload in comming.payload:%@",payload.dictionaryPayload]];
    NSUUID *uuid = [[NSUUID alloc] init];
    NSDictionary *resultDic = @{@"method":@"didReceiveIncomingPushWithPayload",@"payload":payload.dictionaryPayload,@"uuidString":uuid.UUIDString};
    
    NSString *title = nil;
    NSNumber *voIPHasVideo = nil;
    NSString *voIPHandleValue = nil;
    NSNumber *voIPHandleType = nil;
    
    // 取 zego 字段
    NSDictionary *zegoDic = [payload.dictionaryPayload safeObjectForKey:@"zego"];
    if([_utils isNotNull:zegoDic]){
        
        voIPHasVideo = [zegoDic safeObjectForKey:@"voip_has_video"];
        voIPHandleValue = [zegoDic safeObjectForKey:@"voip_handle_value"];
        voIPHandleType = [zegoDic safeObjectForKey:@"voip_handle_type"];
    }
    
    if(_settings.cxProvider == nil){
        _settings.cxProvider = [[CXProvider alloc] initWithConfiguration:_settings.cxProviderConfiguration];
        [_settings.cxProvider setDelegate:self queue:dispatch_get_main_queue()];
    }
    if(_settings.cxCallController == nil){
        _settings.cxCallController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
    }
    

    
    NSObject *aps = [[payload dictionaryPayload] safeObjectForKey:@"aps"];
    
    // 判断 alert 为 string 还是 map, string 直接赋值给 title, map 取其中的 title ,如果对应的值为空则不赋值
    if([_utils isNotNull:aps] && [aps isKindOfClass:[NSDictionary class]]){
        NSDictionary *apsDic = (NSDictionary *)aps;
        NSObject *alertObj = [apsDic safeObjectForKey:@"alert"];
        if([_utils isNotNull:alertObj] && [alertObj isKindOfClass:[NSDictionary class]]){
            NSString *tmpTitle = [((NSDictionary *)alertObj) safeObjectForKey:@"title"];
            if([_utils isNotNull:tmpTitle]){
                title = tmpTitle;
            }
        }else if([_utils isNotNull:alertObj] && [alertObj isKindOfClass:[NSString class]]){
            title = (NSString *)alertObj;
        }
    }
    
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    if([_utils isNotNull:voIPHasVideo]){
        update.hasVideo = [voIPHasVideo boolValue];
    }
    if([_utils isNotNull:voIPHandleType] && [_utils isNotNull:voIPHandleValue]){
        switch ((CXHandleType)[voIPHandleType integerValue]) {
            case CXHandleTypeGeneric:
            case CXHandleTypePhoneNumber:
            case CXHandleTypeEmailAddress:{
                update.remoteHandle =[[CXHandle alloc] initWithType:(CXHandleType)[voIPHandleType integerValue] value:voIPHandleValue];
                break;
            }
            default:
                [_utils wirteCustomLog:[NSString stringWithFormat:@"voIP handle type enum is index out of range.vaule:%ld",[voIPHandleType integerValue]]];
                break;
        }
        
    }
    if([_utils isNotNull:title]){
        update.localizedCallerName = title;
    }
    
    
    [_settings.cxProvider reportNewIncomingCallWithUUID:uuid update:update completion:^(NSError * _Nullable error) {
        NSMutableString *log = [NSMutableString stringWithFormat:@"didReceiveIncomingPush completion. title:%@ ",
                        title];
        [log appendFormat:@"call id:%@ ",[payload.dictionaryPayload safeObjectForKey:@"call_id"]];
        [log appendFormat:@"error:%@",error];
        [self.utils
              wirteCustomLog:log];
        completion();
    }];
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:resultDic];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] didReceiveIncomingPushWithPayload UUID:%@",uuid.UUIDString]];
        _settings.event(resultDic);
    }
}

#pragma mark - CXProviderDelegate delegate

//当接收到呼叫重置时 调用的函数，这个函数必须被实现，其不需做任何逻辑，只用来重置状态
- (void)providerDidReset:(CXProvider *)provider{
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"providerDidReset" forKey:@"method"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] providerDidReset."]];
        _settings.event(eventMap);
    }
}

//呼叫开始时回调
- (void)providerDidBegin:(CXProvider *)provider{
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"providerDidBegin" forKey:@"method"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] providerDidBegin."]];
        _settings.event(eventMap);
    }
}
//音频会话激活状态的回调
- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession{
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"didActivateAudioSession" forKey:@"method"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] didActivateAudioSession."]];
        _settings.event(eventMap);
    }
}
//音频会话停用的回调
- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession{
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"didDeactivateAudioSession" forKey:@"method"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] didDeactivateAudioSession."]];
        _settings.event(eventMap);
    }
}
//行为超时的回调
- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"timedOutPerformingAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] timedOutPerformingAction."]];
        _settings.event(eventMap);
    }
}
//有事务被提交时调用
//如果返回YES 则表示事务被捕获处理 后面的回调都不会调用 如果返回NO 则表示事务不被捕获，会回调后面的函数
- (BOOL)provider:(CXProvider *)provider executeTransaction:(CXTransaction *)transaction{
    return NO;
}
//点击开始按钮的回调
- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performStartCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXStartCallAction:action] forKey:@"action"];
    
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performStartCallAction.seq:%@",seq]];
        _settings.event(eventMap);
        
    }
}
//点击接听按钮的回调
- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performAnswerCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXAnswerCallAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performAnswerCallAction.seq:%@",seq]];
        _settings.event(eventMap);
    }
}
//点击结束按钮的回调
- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performEndCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXEndCallAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performEndCallAction.seq:%@",seq]];
        _settings.event(eventMap);
    }
}
//点击保持通话按钮的回调
- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performSetHeldCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXSetHeldCallAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performSetHeldCallAction.seq:%@",seq]];
        _settings.event(eventMap);
    }
}
//点击静音按钮的回调
- (void)provider:(CXProvider *)provider performSetMutedCallAction:(CXSetMutedCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performSetMutedCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXSetMutedCallAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performSetMutedCallAction.seq:%@",seq]];
        _settings.event(eventMap);
    }
}
//点击组按钮的回调
- (void)provider:(CXProvider *)provider performSetGroupCallAction:(CXSetGroupCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performSetGroupCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXSetGroupCallAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performSetMutedCallAction.seq:%@",seq]];
        _settings.event(eventMap);
    }
}
//DTMF功能回调
- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action{
    NSString *seq = [self.utils generateSeqStr];
    [_settings.actionMap safeSetObject:action forKey:seq];
    
    NSMutableDictionary *eventMap = [[NSMutableDictionary alloc] init];
    [eventMap safeSetObject:@"performPlayDTMFCallAction" forKey:@"method"];
    [eventMap safeSetObject:seq forKey:@"seq"];
    [eventMap safeSetObject:[_converter mCXPlayDTMFCallAction:action] forKey:@"action"];
    
    if(_settings.event == nil){
        [_settings addResultDictionaryToHoldNomalResultArray:eventMap];
    }else{
        [self.utils
              wirteCustomLog:[NSString stringWithFormat:@"[CALLBACK] performPlayDTMFCallAction.seq:%@",seq]];
        _settings.event(eventMap);
    }
}


@end
