//
//  LocationService.m
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import "LocationService.h"
#import "RecordModelManager.h"
#import <UIKit/UIKit.h>

@interface LocationService()<CLLocationManagerDelegate>


@end

@implementation LocationService
#pragma mark - lifecycle
+ (instancetype)sharedService {
    static LocationService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[LocationService alloc] init];
    });
    return service;
}

#pragma mark - private
#pragma mark - public
- (void)requestAutorizationIfNeeded {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - event respond

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [[RecordModelManager sharedManager] addRecordWithLocation:locations.lastObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationServiceDidUpdateLocation object:nil userInfo:nil];
}

#pragma mark - lazy load
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - setters & getter


@end
