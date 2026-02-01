//
//  ZPNsUtils.m
//  zego_zpns
//
//  Created by 武耀琳 on 2023/6/29.
//

#import "ZPNsUtils.h"
#import "ZPNsAppEnvironmentUtil.h"
#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
static NSString *const kEntitlementsAPSEnvironmentKey = @"Entitlements.aps-environment";
#else
static NSString *const kEntitlementsAPSEnvironmentKey =
    @"Entitlements.com.apple.developer.aps-environment";
#endif
static NSString *const kAPSEnvironmentDevelopmentValue = @"development";


@implementation ZPNsUtils

+(bool)wirteCustomLog:(NSString *)customLog{
    Class ZIM = NSClassFromString(@"ZPNs");
    if ([[NSClassFromString(@"ZPNs") alloc] init] != nil) {
        SEL selector = NSSelectorFromString(@"writeCustomLog:moduleName:");
        IMP imp = [ZIM methodForSelector:selector];
        void (*func)(id, SEL, NSString *,NSString *) = (void (*)(id, SEL, NSString *, NSString *))imp;
        func(ZIM, selector, customLog, @"Flutter");
        return true;
    }
    return false;
}

+ (NSString *)getHexStringForData:(NSData *)data {
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

+ (BOOL)isNotNull:(NSObject *)object{
    if(object == nil || object == NULL || [object isEqual:[NSNull null]]){
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isSandboxApp{
    static BOOL isSandboxApp = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      isSandboxApp = ![ZPNsUtils isProductionApp];
    });
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"Auto analyze isSandboxApp:%@",isSandboxApp?@"YES":@"NO"]];
    return isSandboxApp;
}


+(BOOL) isProductionApp {
 const BOOL defaultAppTypeProd = YES;

 NSError *error = nil;
 if ([ZPNsAppEnvironmentUtil isSimulator]) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"Running InstanceID on a simulator doesn't have APNS.Use prod profile by default."]];
   return defaultAppTypeProd;
 }

 if ([ZPNsAppEnvironmentUtil isFromAppStore]) {
   // Apps distributed via AppStore or TestFlight use the Production APNS certificates.
   return defaultAppTypeProd;
 }
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
 NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
     stringByAppendingPathComponent:@"embedded.provisionprofile"];
#elif TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
 NSString *path = [[[NSBundle mainBundle] bundlePath]
     stringByAppendingPathComponent:@"embedded.mobileprovision"];
#endif

 if ([ZPNsAppEnvironmentUtil isAppStoreReceiptSandbox] && !path.length) {
   // Distributed via TestFlight
   return defaultAppTypeProd;
 }

 NSMutableData *profileData = [NSMutableData dataWithContentsOfFile:path options:0 error:&error];

 if (!profileData.length || error) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"Error while reading embedded mobileprovision . Error:%@",error]];
   return defaultAppTypeProd;
 }

 // The "embedded.mobileprovision" sometimes contains characters with value 0, which signals the
 // end of a c-string and halts the ASCII parser, or with value > 127, which violates strict 7-bit
 // ASCII. Replace any 0s or invalid characters in the input.
 uint8_t *profileBytes = (uint8_t *)profileData.bytes;
 for (int i = 0; i < profileData.length; i++) {
   uint8_t currentByte = profileBytes[i];
   if (!currentByte || currentByte > 127) {
     profileBytes[i] = '.';
   }
 }

 NSString *embeddedProfile = [[NSString alloc] initWithBytesNoCopy:profileBytes
                                                            length:profileData.length
                                                          encoding:NSASCIIStringEncoding
                                                      freeWhenDone:NO];

 if (error || !embeddedProfile.length) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"Error while reading embedded mobileprovision . Error:%@",error]];
   return defaultAppTypeProd;
 }

 NSScanner *scanner = [NSScanner scannerWithString:embeddedProfile];
 NSString *plistContents;
 if ([scanner scanUpToString:@"<plist" intoString:nil]) {
   if ([scanner scanUpToString:@"</plist>" intoString:&plistContents]) {
     plistContents = [plistContents stringByAppendingString:@"</plist>"];
   }
 }

 if (!plistContents.length) {
   return defaultAppTypeProd;
 }

 NSData *data = [plistContents dataUsingEncoding:NSUTF8StringEncoding];
 if (!data.length) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"Couldn't read plist fetched from embedded mobileprovision"]];
   return defaultAppTypeProd;
 }

 NSError *plistMapError;
 id plistData = [NSPropertyListSerialization propertyListWithData:data
                                                          options:NSPropertyListImmutable
                                                           format:nil
                                                            error:&plistMapError];
 if (plistMapError || ![plistData isKindOfClass:[NSDictionary class]]) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"plistMapError or plist data is not kind of class NSDictionary.Error:%@",error]];
   return defaultAppTypeProd;
 }
 NSDictionary *plistMap = (NSDictionary *)plistData;

 if ([plistMap valueForKeyPath:@"ProvisionedDevices"]) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"Provisioning profile has specifically provisioned devices.most likely a Dev profile."]];
 }

 NSString *apsEnvironment = [plistMap valueForKeyPath:kEntitlementsAPSEnvironmentKey];
    [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"APNS Environment in profile: %@", apsEnvironment]];
    
 // No aps-environment in the profile.
 if (!apsEnvironment.length) {
     [ZPNsUtils wirteCustomLog:[NSString stringWithFormat:@"No aps-environment set. If testing on a device APNS is not "
                                @"correctly configured. Please recheck your provisioning "
                                @"profiles. If testing on a simulator this is fine since APNS "
                                @"doesn't work on the simulator."]];
   return defaultAppTypeProd;
 }

 if ([apsEnvironment isEqualToString:kAPSEnvironmentDevelopmentValue]) {
   return NO;
 }

 return defaultAppTypeProd;
}

@end
