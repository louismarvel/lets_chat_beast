//
//  NSMutableDictionary+safeInvoke.m
//  zego_callkit
//
//  Created by 武耀琳 on 2023/9/26.
//

#import "NSMutableDictionary+zegoCallkitSafeInvoke.h"

@implementation NSMutableDictionary (callkitSafeInvoke)

-(void)safeSetObject:(nullable id)object
              forKey:(nonnull NSString *)key{
    if(object == nil || object == NULL || [object isEqual:[NSNull null]]){
        [self setObject:[NSNull null] forKey:key];
        return;
    }
    [self setObject:object forKey:key];
}


@end
