#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerCallkitPlugin];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


-(void)registerCallkitPlugin{
    Class zegoCallkitPluginClass = NSClassFromString(@"ZegoCallkitPlugin");
    if (!zegoCallkitPluginClass) {
        NSLog(@"Cannot find ZegoCallkitPlugin Class");
        return;
    }
    SEL registerVoIPTokenSelector = NSSelectorFromString(@"registerVoIPToken");

    if ([zegoCallkitPluginClass respondsToSelector:registerVoIPTokenSelector]) {
        // Step 4: 使用 NSInvocation 调用方法
        NSMethodSignature *signature = [zegoCallkitPluginClass methodSignatureForSelector:registerVoIPTokenSelector];
        if (signature) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setSelector:registerVoIPTokenSelector];
            [invocation setTarget:zegoCallkitPluginClass];
            [invocation invoke];
            NSLog(@"invoke success.");
        } else {
            NSLog(@"cannot get signature for registerVoIPToken");
        }
    } else {
        NSLog(@"not found registerVoIPToken");
    }
}

@end
