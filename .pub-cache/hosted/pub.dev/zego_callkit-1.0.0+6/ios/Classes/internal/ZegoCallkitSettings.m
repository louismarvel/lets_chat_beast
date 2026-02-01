//
//  ZegoCallkitSettings.m
//  zego_callkit
//
//  Created by 武耀琳 on 2023/9/26.
//

#import "ZegoCallkitSettings.h"
#import "utils/ZegoCallkitUtils.h"


@interface ZegoCallkitSettings()

@property NSMutableArray<NSDictionary *> *holdResultArray_;

@property ZegoCallkitUtils *utils_;

@end


@implementation ZegoCallkitSettings


+(ZegoCallkitSettings *)sharedInstance{
      static ZegoCallkitSettings *sharedInstance = nil;
      static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          sharedInstance = [[super allocWithZone:NULL] init];
          sharedInstance.cxCallController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
          sharedInstance.actionMap = [[NSMutableDictionary alloc] init];
          sharedInstance.utils_ = [ZegoCallkitUtils sharedInstance];
      });
      return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}


- (void)addResultDictionaryToHoldNomalResultArray:(NSDictionary *)result{
    if(_holdResultArray_ == nil){
        _holdResultArray_ = [[NSMutableArray alloc] init];
        NSString *seq = [result objectForKey:@"seq"];
        NSMutableString *log = [NSMutableString stringWithFormat:@"hold event:%@",[result objectForKey:@"method"]];
        if(seq != nil){
            [log appendString:[NSString stringWithFormat:@"seq:%@",seq]];
        }
        [_utils_ wirteCustomLog:log];
    }
    [_holdResultArray_ addObject:result];
}

- (void)clearHoldNomalResultArray{
    if(_holdResultArray_ == nil){
        return;
    }
    if(_event == nil){
        return;
    }
    for (NSDictionary *resultMap in  self.holdResultArray_) {
        NSString *seq = [resultMap objectForKey:@"seq"];
        NSMutableString *log = [NSMutableString stringWithFormat:@"[CALLBACK] %@.By clear hold map.",[resultMap objectForKey:@"method"]];
        if(seq != nil){
            [log appendString:[NSString stringWithFormat:@"seq:%@",seq]];
        }
        [_utils_ wirteCustomLog:log];
        _event(resultMap);
    }
    [_holdResultArray_ removeAllObjects];
}


@end
