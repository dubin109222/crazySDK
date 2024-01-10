//
//  AppDelegate.m
//  CSSDKOCDemo
//
//  Created by Lee on 26/07/2022.
//

#import "AppDelegate.h"
#import "OCTestViewController.h"
#import <CrazySnake/CrazySnake.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Adjust.h>


@interface AppDelegate ()<AdjustDelegate>

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    OCTestViewController* vc = [[OCTestViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.view.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [CrazyPlatform initAdjustFrom:@"j7o711oob5s0" environment:ADJEnvironmentSandbox adjustDelegate:self];
    NSLog(@"adjust init...");
    [CrazyPlatform sdkWithApplication:application didFinishLaunchingWithOptions:launchOptions];

    
    return YES;
}


- (void)adjustAttributionChanged:(ADJAttribution *)attribution {
    NSLog(@"adjust is init\n%@",[Adjust attribution]);
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
