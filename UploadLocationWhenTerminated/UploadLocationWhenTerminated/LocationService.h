//
//  LocationService.h
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString *LocationServiceDidUpdateLocation = @"LocationServiceDidUpdateLocation";

@interface LocationService : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (instancetype)sharedService;
- (void)requestAutorizationIfNeeded;

@end
