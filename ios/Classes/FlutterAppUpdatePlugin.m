#import "FlutterAppUpdatePlugin.h"

@implementation FlutterAppUpdatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"azhon_app_update"
                                     binaryMessenger:[registrar messenger]];
    FlutterAppUpdatePlugin* instance = [[FlutterAppUpdatePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"getVersionCode"]){
        NSString *versionCode = NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
        result(@([versionCode intValue]));
    } else if([call.method isEqualToString:@"getVersionName"]){
        NSString *versionName = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
        result(versionName);
    }else if([call.method isEqualToString:@"update"]){
        [self update:call.arguments];
    }else if([call.method isEqualToString:@"cancel"]){
        result(@(YES));
    }
}
#pragma 版本更新
-(void)openAppStore:(NSString *)iOSUrl {
    // 对URL进行编码
    NSString *encodedUrl = [iOSUrl stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@""] invertedSet]];

    // 将 NSString 转换为 NSURL
    NSURL *url = [NSURL URLWithString:encodedUrl];

    // 检查是否可以打开该 URL
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        // 打开 URL
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Successfully opened the URL.");
            } else {
                NSLog(@"Failed to open the URL.");
            }
        }];
    } else {
        NSLog(@"Cannot open the URL.");
    }
}
#pragma 打开AppStore
-(void)openAppStore:(NSString *)iOSUrl{
    NSString *url = [iOSUrl stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@""] invertedSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma 获取UIViewController 然后可以跳转
-(UIViewController *)findViewController:(UIWindow *)window {
    UIWindow *windowToUse = window;
    if (windowToUse == nil) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                windowToUse = window;
                break;
            }
        }
    }
    UIViewController *topController = windowToUse.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}
@end
