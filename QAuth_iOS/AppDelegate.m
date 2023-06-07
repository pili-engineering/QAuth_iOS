//
//  AppDelegate.m
//  QAuth_iOS
//
//  Created by sunmu on 2023/5/22.
//

#import "AppDelegate.h"
#import <QNAuthSDK/QNAuthSDK.h>
//#import "IQKeyboardManager.h"
#import "TestViewController.h"
#import <SVProgressHUD.h>

//#define APPID  @"300012355505"
//#define APPKEY @"C7F90B66F9CCABB47ACC8E62D6EF19FE"
//#define APPSECRET @"D29F998A52CC490D81236A9C5E3B51E7"

//#define APPID  @"XUaD4z2e"
//#define APPKEY @"oPV85era"
//#define APPSECRET @"D29F998A52CC490D81236A9C5E3B51E7"

#define APPID  @"h6a44ay9u"
#define APPKEY @"pixroaxtdLWqsml9dE960mXp9jvgSKpsTFFoX5JU"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    TestViewController *naviRootVc = [[TestViewController alloc] init];
    UINavigationController *windowRootVc = [[UINavigationController alloc] initWithRootViewController:naviRootVc];
    self.window.rootViewController = windowRootVc;
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].delegate.window = self.window;

    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setMaximumDismissTimeInterval:3];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHUDTappedNotification:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    
    //存好APPID和APPKEY
    [[NSUserDefaults standardUserDefaults] setValue:APPID forKey:@"APPID"];
    [[NSUserDefaults standardUserDefaults] setValue:APPKEY forKey:@"APPKEY"];;
    
    [QNAuthSDKManager initWithAppId:APPID appKey:APPKEY complete:^(QNCompleteResult * _Nonnull completeResult) {
        
    }];
    
//    //注册SDK
//    [UAFSDKLogin.shareLogin registerAppId:APPID AppKey:APPKEY];
//
//    //是否打印日志
//    [UAFSDKLogin.shareLogin printConsoleEnable:YES];
    
    return YES;
}


/**
 转换显示资料
 */
- (NSString *)changeShowInfo:(id)sender {
    NSString *message = @"";
    for (id key in [sender allKeys]) {
        
        id value = sender[key];
        BOOL isDict = [value isKindOfClass:NSDictionary.class];
        
        message = isDict ? [message stringByAppendingFormat:@"\n%@ = %@",key, [self changeShowInfo:value]] : [message stringByAppendingFormat:@"\n%@ = \"%@\"",key,sender[key]];
    }
    
    return message;
}

- (void)showInfo:(NSDictionary *)sender {
    NSString *message = [self changeShowInfo:sender];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"%@",message]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
 

+ (void)handleHUDTappedNotification: (NSNotification *)notification {
    [SVProgressHUD dismiss];
}


@end
