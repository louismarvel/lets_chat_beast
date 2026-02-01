
//
//  ZegoCallkitUtils.m
//  zego_callkit
//
//  Created by 武耀琳 on 2023/9/26.
//

#import "ZegoCallkitUtils.h"

static unsigned int seq = 0;

@implementation ZegoCallkitUtils

+(ZegoCallkitUtils *)sharedInstance{
    static ZegoCallkitUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

-(bool)wirteCustomLog:(NSString *)customLog{
    Class ZPNs = NSClassFromString(@"ZPNs");
    if ([[NSClassFromString(@"ZPNs") alloc] init] != nil) {
        SEL selector = NSSelectorFromString(@"writeCustomLog:moduleName:");
        IMP imp = [ZPNs methodForSelector:selector];
        void (*func)(id, SEL, NSString *,NSString *) = (void (*)(id, SEL, NSString *, NSString *))imp;
        func(ZPNs, selector, customLog, @"Flutter");
        return true;
    }
    return false;
}

-(BOOL)isNotNull:(NSObject *)object{
    if(object == nil || object == NULL || [object isEqual:[NSNull null]]){
        return NO;
    }else{
        return YES;
    }
}

-(NSString *)getHexStringForData:(NSData *)data {
#if TARGET_OS_IPHONE
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {

        if (![data isKindOfClass:[NSData class]]) {
            return @"";
        }
        NSUInteger len = [data length];
        char *chars = (char *)[data bytes];
        NSMutableString *hexString = [[NSMutableString alloc] init];
        for (NSUInteger i = 0; i < len; i++) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
        }
        return hexString;
    } else {
        NSString *myToken = [[data description]
            stringByTrimmingCharactersInSet:[NSCharacterSet
                                                characterSetWithCharactersInString:@"<>"]];
        myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        return myToken;
    }
#endif
#if TARGET_OS_OSX
    if (![data isKindOfClass:[NSData class]]) {
        return @"";
    }
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
#endif
}

-(NSString *)generateSeqStr{
    ++seq;
    NSString *seqStr = [NSString stringWithFormat:@"native%u",seq];
    return seqStr;
}


@end
