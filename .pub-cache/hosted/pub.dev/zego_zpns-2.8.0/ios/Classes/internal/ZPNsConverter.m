//
//  ZPNsConverter.m
//  zego_zpns
//
//  Created by 武耀琳 on 2023/3/9.
//

#import "ZPNsConverter.h"

@implementation ZPNsConverter

+(ZPNsConfig *)oZPNsPushConfig:(NSDictionary *)configMap{
    ZPNsConfig *config = [[ZPNsConfig alloc] init];
    if([configMap objectForKey:@"appType"]){
        config.appType = [[configMap objectForKey:@"appType"] unsignedIntValue];
    }
    return config;
}

@end
