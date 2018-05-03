//
//  TDHomeViewController.m
//  TesstDemo
//
//  Created by chenjie on 2018/4/11.
//  Copyright © 2018年 sdf12. All rights reserved.
//

#import "TDHomeViewController.h"
#import <Masonry/Masonry.h>
#import <MapKit/MapKit.h>

@interface TDHomeViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *standardManager;
@property (nonatomic, strong) CLLocationManager *significantManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSTimer *timer;


@end


@implementation TDHomeViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLocationManagers];
    [self confirgureViews];
    [self configureDefaultData];
    [self configureTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)updateViewConstraints {
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - event respond
- (void)timerInvoked {
    NSLog(@"Stadard     location:%@",self.standardManager.location.description);
    NSLog(@"Significant location:%@",self.significantManager.location.description);
}

#pragma mark - private
- (void)confirgureViews {
    [self.view addSubview:self.mapView];
    [self.view setNeedsUpdateConstraints];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configureDefaultData {
}

- (void)configureLocationManagers {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.standardManager = [[CLLocationManager alloc] init];
        self.standardManager.delegate = self;
        if ([self.standardManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.standardManager requestAlwaysAuthorization];
        }
        [self.standardManager startUpdatingLocation];
        
        self.significantManager = [[CLLocationManager alloc] init];
        self.significantManager.delegate = self;
        if ([self.significantManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.significantManager requestAlwaysAuthorization];
        }
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            [self.significantManager startMonitoringSignificantLocationChanges];
        }
    });
}

- (void)configureTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerInvoked) userInfo:nil repeats:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSString *identifier = nil;
//    if (manager == self.standardManager) {
//        identifier = @"Stadard";
//    } else {
//        identifier = @"Significant";
//    }
//    NSLog(@"%@ has updated location:%@",identifier,locations.lastObject.description);
}


#pragma mark - lazy load
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    return _mapView;
}

@end
