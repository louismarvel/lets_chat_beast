//
//  ZegoCallkitConverter.m
//  zego_callkit
//
//  Created by 武耀琳 on 2023/9/26.
//

#import "ZegoCallkitConverter.h"
#import "utils/NSDictionary+zegoCallkitSafeInvoke.h"
#import "utils/NSMutableDictionary+zegoCallkitSafeInvoke.h"

@implementation ZegoCallkitConverter

+(ZegoCallkitConverter *)sharedInstance{
    static ZegoCallkitConverter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

-(CXCallUpdate *) oCXCallUpdate:(NSDictionary *)updateMap{
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    if([updateMap safeObjectForKey:@"supportsDTMF"])update.supportsDTMF = [[updateMap safeObjectForKey:@"supportsDTMF"] boolValue];
    if([updateMap safeObjectForKey:@"supportsHolding"])update.supportsHolding = [[updateMap safeObjectForKey:@"supportsHolding"] boolValue];
    if([updateMap safeObjectForKey:@"supportsGrouping"])update.supportsGrouping = [[updateMap safeObjectForKey:@"supportsGrouping"] boolValue];
    if([updateMap safeObjectForKey:@"supportsUngrouping"])update.supportsUngrouping = [[updateMap safeObjectForKey:@"supportsUngrouping"] boolValue];
    if([updateMap safeObjectForKey:@"hasVideo"])update.hasVideo = [[updateMap safeObjectForKey:@"hasVideo"] boolValue];
    if([updateMap safeObjectForKey:@"remoteHandle"]){
        NSDictionary *remoteHandleMap = [updateMap safeObjectForKey:@"remoteHandle"];
        update.remoteHandle = [[CXHandle alloc] initWithType:[[remoteHandleMap safeObjectForKey:@"type"] intValue] value:[remoteHandleMap safeObjectForKey:@"value"]];
    }
    if([updateMap safeObjectForKey:@"localizedCallerName"])update.localizedCallerName = [updateMap safeObjectForKey:@"localizedCallerName"];
    return update;
}

-(nullable NSDictionary *)mCXHandle:(CXHandle *)handle{
    if(handle == nil || [handle isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *handleDictionary = [[NSMutableDictionary alloc] init];
    [handleDictionary safeSetObject:[NSNumber numberWithInteger:handle.type] forKey:@"type"];
    [handleDictionary safeSetObject:handle.value forKey:@"value"];
    
    return handleDictionary;
}




-(nullable NSDictionary *) mCXAction:(CXAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSDictionary *actionDictionary = [[NSDictionary alloc] init];
    return actionDictionary;
}

-(nullable NSDictionary *) mCXCallAction:(CXCallAction *)callAction{
    if(callAction == nil || [callAction isEqual:[NSNull null]]){
        return nil;
    }
    
    NSMutableDictionary *actionDictionary = [[NSMutableDictionary alloc] initWithDictionary:[self mCXAction:callAction]];
    
    
    [actionDictionary safeSetObject:callAction.callUUID.UUIDString forKey:@"callUUIDString"];
    
    return actionDictionary;
}

-(nullable NSDictionary *) mCXStartCallAction:(CXStartCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary: [self mCXCallAction:action]];
    [actionMap safeSetObject:[self mCXHandle:action.handle] forKey:@"handle"];
    [actionMap safeSetObject:action.contactIdentifier forKey:@"contactIdentifier"];
    [actionMap safeSetObject:[NSNumber numberWithBool:action.video] forKey:@"video"];
    
    
    return actionMap;
}

-(nullable NSDictionary *)mCXAnswerCallAction:(CXCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary:[self mCXCallAction:action]];
    return actionMap;
}

-(nullable NSDictionary *)mCXEndCallAction:(CXEndCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary:[self mCXCallAction:action]];
    return actionMap;
}

-(nullable NSDictionary *)mCXSetHeldCallAction:(CXSetHeldCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary:[self mCXCallAction:action]];
    [actionMap safeSetObject:[NSNumber numberWithBool:action.onHold] forKey:@"onHold"];
    return actionMap;
}

-(nullable NSDictionary *)mCXSetMutedCallAction:(CXSetMutedCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary:[self mCXCallAction:action]];
    [actionMap safeSetObject:[NSNumber numberWithBool:action.muted] forKey:@"muted"];
    return actionMap;
}

-(nullable NSDictionary *)mCXSetGroupCallAction:(CXSetGroupCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary:[self mCXCallAction:action]];
    return actionMap;
}

-(nullable NSDictionary *)mCXPlayDTMFCallAction:(CXPlayDTMFCallAction *)action{
    if(action == nil || [action isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *actionMap = [[NSMutableDictionary alloc] initWithDictionary:[self mCXCallAction:action]];
    [actionMap safeSetObject:action.digits forKey:@"digits"];
    [actionMap safeSetObject:[NSNumber numberWithInteger:action.type] forKey:@"type"];

    return actionMap;
}


@end
