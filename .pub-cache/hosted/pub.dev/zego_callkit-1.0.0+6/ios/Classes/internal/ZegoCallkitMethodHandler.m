//
//  ZegoCallkitMethodHandler.m
//  zego_callkit
//
//  Created by 武耀琳 on 2023/9/27.
//

#import "ZegoCallkitMethodHandler.h"
#import "utils/NSDictionary+zegoCallkitSafeInvoke.h"
#import "utils/NSMutableDictionary+zegoCallkitSafeInvoke.h"
#import "ZegoCallkitSettings.h"
#import "ZegoCallkitConverter.h"
#import "utils/ZegoCallkitUtils.h"
#import "ZegoCallkitEventHandler.h"

@interface ZegoCallkitMethodHandler()

@property (nonatomic,strong) ZegoCallkitSettings *settings;

@property (nonatomic,strong) ZegoCallkitUtils *utils;

@end


@implementation ZegoCallkitMethodHandler

+(ZegoCallkitMethodHandler *)sharedInstance{
    static ZegoCallkitMethodHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.settings = [ZegoCallkitSettings sharedInstance];
        sharedInstance.utils = [ZegoCallkitUtils sharedInstance];
    });
    return sharedInstance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}
#pragma mark - API
-(void)setInitConfig:(FlutterMethodCall *)call result:(FlutterResult)result{
    
    NSDictionary *configMap = [call.arguments safeObjectForKey:@"config"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:configMap forKey:@"zegoCallKitInitConfig"];
    [self setInitConfig:configMap];
}

-(void)reportIncomingCallWithTitle:(FlutterMethodCall *)call result:(FlutterResult)result {
    [self reportIncomingCallWithTitle:[call.arguments safeObjectForKey:@"cxCallUpdate"] UUID:[call.arguments safeObjectForKey:@"uuidString"] completion:^(NSError * _Nullable error) {
        if(error){
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld",error.code] message:[error localizedDescription]  details:nil]);
        }else{
            result(nil);
        }
    }];
}

-(void)reportCallEnded:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSNumber *endedReason = [call.arguments safeObjectForKey:@"endedReason"];
    NSString *uuidSeq = [call.arguments safeObjectForKey:@"uuidString"];
    [self reportCallEndedWithUUID:uuidSeq reason:[endedReason intValue]];
    result(nil);
}


-(void)reportCallUpdate:(FlutterMethodCall *)call result:(FlutterResult)result{
    [self reportCallUpdateWithUUID:[call.arguments safeObjectForKey:@"cxCallUpdate"] UUID:[call.arguments safeObjectForKey:@"uuidString"]];
    result(nil);
}

-(void)reportOutgoingCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    [self reportOutgoingCallWithUUID:[call.arguments safeObjectForKey:@"uuidString"]];
    result(nil);
}


-(void)callKitActionFail:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *seq = [call.arguments safeObjectForKey:@"seq"];
    [self ActionFail:seq];
}
-(void)callKitActionFulfill:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *seq = [call.arguments safeObjectForKey:@"seq"];
    [self ActionFullFill:seq];
}


-(void)setInitConfig:(NSDictionary *)configMap{
    NSString *localizedName = [configMap safeObjectForKey:@"localizedName"];
    NSNumber *supportVideo = [configMap safeObjectForKey:@"supportsVideo"];
    NSNumber *maximumCallsPerCallGroup = [configMap safeObjectForKey:@"maximumCallsPerCallGroup"];
    NSNumber *maximumCallGroups = [configMap safeObjectForKey:@"maximumCallGroups"];
    NSArray<NSNumber *> *supportedHandleTypes = [configMap safeObjectForKey:@"supportedHandleTypes"];
    NSString *iconTemplateImageName = [configMap safeObjectForKey:@"iconTemplateImageName"];
    
    _settings.cxProviderConfiguration = [[CXProviderConfiguration alloc] initWithLocalizedName:localizedName];
    if(supportVideo != nil)_settings.cxProviderConfiguration.supportsVideo = [supportVideo boolValue];
    if(maximumCallsPerCallGroup != nil)_settings.cxProviderConfiguration.maximumCallsPerCallGroup = [maximumCallsPerCallGroup unsignedIntegerValue];
    if(maximumCallGroups != nil)_settings.cxProviderConfiguration.maximumCallGroups = [maximumCallGroups unsignedIntegerValue];
    if(supportedHandleTypes != nil)_settings.cxProviderConfiguration.supportedHandleTypes = [[NSSet alloc] initWithArray:supportedHandleTypes];
    if(iconTemplateImageName != nil)_settings.cxProviderConfiguration.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:iconTemplateImageName]);
    [_utils wirteCustomLog:[NSString stringWithFormat:@"setInitConfig, localizedName:%@,supportVideo:%@,maximumCallsPerCallGroup:%@,maximumCallGroups:%@,supportedHandleTypes%@,iconTemplateImageName:%@",localizedName,supportVideo,maximumCallsPerCallGroup,maximumCallGroups,supportedHandleTypes,iconTemplateImageName]];
}


-(void)enableVoIP:(BOOL)isProduct{
    _settings.enableVoIP = YES;
    _settings.isProduct = isProduct;
    if(_settings.event != nil){
        [_settings clearHoldNomalResultArray];
    }
    if(_settings.voIPToken != nil){
        Class ZPNs = NSClassFromString(@"ZPNs");
        if (ZPNs == nil) {
            [_utils wirteCustomLog:@"ZPNs is not integrated."];
            return;
        }
        id zpns = [ZPNs valueForKey:@"shared"];
        if(zpns == nil){
            [_utils wirteCustomLog:@"ZPNs did not find the method named shared."];
            return;
        }
        SEL selector = NSSelectorFromString(@"setVoipToken:isProduct:");
        NSMethodSignature *methodSignature = [ZPNs instanceMethodSignatureForSelector:selector];
        if(methodSignature){
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setTarget:zpns];
            NSData *voIPToken = _settings.voIPToken;
            [invocation setArgument:&voIPToken atIndex:2];
            BOOL isProduct = _settings.isProduct;
            [invocation setArgument:&isProduct atIndex:3];
            [invocation invoke];
        }
        
    }
    
}

-(void)isSetEvent:(BOOL)isSetEvent{
    if(isSetEvent == NO){
        return;
    }
    if(_settings.enableVoIP == YES){
        [_settings clearHoldNomalResultArray];
    }
}

-(void)reportIncomingCallWithTitle:(NSDictionary *)updateMap UUID:(NSString *)uuidString completion:(void (^)(NSError *_Nullable error))completion{
    CXCallUpdate *update = [[ZegoCallkitConverter sharedInstance] oCXCallUpdate:updateMap];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    if(![self.utils isNotNull:uuid]){
        NSError *error = [NSError errorWithDomain:@"com.zego.zego_zpns" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Assign nsuuid failed. invalid uuid strings."}];
        [_utils wirteCustomLog:[NSString stringWithFormat:@"Assign nsuuid failed. invalid strings.uuidString:%@",uuidString]];
        completion(error);
        return;
    }
    if(_settings.cxProvider == nil){
        if(_settings.cxProviderConfiguration){
            
            _settings.cxProvider = [[CXProvider alloc] initWithConfiguration:_settings.cxProviderConfiguration];
            [_settings.cxProvider setDelegate:[ZegoCallkitEventHandler sharedInstance] queue:dispatch_get_main_queue()];
        }else{
            NSError *error = [NSError errorWithDomain:@"com.zego.zego_zpns" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Please invoke setInitConfiguration before invoke reportIncomingCall."}];
            [_utils wirteCustomLog:[NSString stringWithFormat:@"Please invoke setInitConfiguration before invoke reportIncomingCall.uuidString:%@",uuidString]];
            completion(error);
            return;
        }
    }
    if(_settings.cxCallController == nil){
        _settings.cxCallController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
    }
    
    [_settings.cxProvider reportNewIncomingCallWithUUID:uuid update:update completion:completion];
}

- (void)reportCallEndedWithUUID:(NSString *)uuidString reason:(CXCallEndedReason)endedReason{
    [_settings.cxProvider reportCallWithUUID:[[NSUUID alloc] initWithUUIDString:uuidString] endedAtDate:nil reason:endedReason];
}

-(void)reportCallUpdateWithUUID:(NSDictionary *)updateMap UUID:(NSString *)uuidString{
    CXCallUpdate *update = [[ZegoCallkitConverter sharedInstance] oCXCallUpdate:updateMap];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    [_settings.cxProvider reportCallWithUUID:uuid updated:update];
}


-(void)reportOutgoingCallWithUUID:(NSString *)uuidString{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    [_settings.cxProvider reportOutgoingCallWithUUID:uuid connectedAtDate:nil];
}



-(void)ActionFail:(NSString *)seq{
    CXAction *action = [_settings.actionMap safeObjectForKey:seq];
    if([_utils isNotNull:action]){
        [action fail];
        [_settings.actionMap removeObjectForKey:seq];
        [_utils wirteCustomLog:[NSString stringWithFormat:@"report [action fail] success.seq:%@",seq]];
    }else{
        [_utils wirteCustomLog:[NSString stringWithFormat:@"report [action fail] failed. target action not at the action map. seq:%@",seq]];
    }
    
}

-(void)ActionFullFill:(NSString *)seq{
    CXAction *action = [_settings.actionMap safeObjectForKey:seq];
    if([_utils isNotNull:action]){
        [action fulfill];
        [_settings.actionMap removeObjectForKey:seq];
        [_utils wirteCustomLog:[NSString stringWithFormat:@"report [action fulfill] success.seq:%@",seq]];
    }else{
        [_utils wirteCustomLog:[NSString stringWithFormat:@"report [action fulfill] failed. target action not at the action map. seq:%@",seq]];
    }
}

@end
