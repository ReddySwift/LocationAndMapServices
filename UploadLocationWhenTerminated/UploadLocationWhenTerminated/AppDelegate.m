//
//  AppDelegate.m
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "DataViewController.h"
#import "LocationService.h"
#import "RecordModelManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"FinishLaunching"];
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"LocationLaunching"];
    }
    [self setupMainWindow];
    [[LocationService sharedService] requestAutorizationIfNeeded];
    [[LocationService sharedService].locationManager startMonitoringSignificantLocationChanges];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"EnterForeground"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"BecomeActive"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"ResignActive"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"EnterBackground"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[RecordModelManager sharedManager] addRecordWithLocation:nil identifier:@"WillTerminate"];
}

- (void)setupMainWindow {
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.tabBarItem.title = @"Map";
    DataViewController *dataVC = [[DataViewController alloc] init];
    dataVC.tabBarItem.title = @"Data";
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[mapVC, dataVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
}
@end
