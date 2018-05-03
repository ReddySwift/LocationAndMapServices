//
//  TDHomeViewController.m
//  TesstDemo
//
//  Created by chenjie on 2018/4/11.
//  Copyright © 2018年 sdf12. All rights reserved.
//

#import "TDHomeViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TDHomeViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;


@end


@implementation TDHomeViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self confirgureViews];
    [self configureDefaultData];
    [self configureLocationService];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
}

#pragma mark - private
- (void)confirgureViews {
}

- (void)configureDefaultData {
}

- (void)configureLocationService {
    if ([CLLocationManager headingAvailable]) {
        [self.manager startUpdatingHeading];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"UpdateHeading: Heading:%.3f, x:%.3f, y:%.3f, z:%.3f",newHeading.magneticHeading,newHeading.x,newHeading.y,newHeading.z);
}

#pragma mark - lazy load
- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

@end
