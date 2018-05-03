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

@interface TDHomeViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) MKMapView *mapView;


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
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - public


#pragma mark - private
- (void)confirgureViews {
    [self.view addSubview:self.mapView];
    [self.view setNeedsUpdateConstraints];
}

- (void)configureDefaultData {
}

- (void)configureLocationService {
    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.manager requestAlwaysAuthorization];
    }
    
    if ([CLLocationManager headingAvailable]) {
        [self.manager startUpdatingHeading];
    }
}

- (void)lookAtCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D eyeLocation = CLLocationCoordinate2DMake(coordinate.latitude+0.005, coordinate.longitude+0.005);
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:coordinate fromEyeCoordinate:eyeLocation eyeAltitude:20];
    [self.mapView setCamera:camera animated:YES];
}

#pragma mark - event respond
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self lookAtCoordinate:self.mapView.userLocation.location.coordinate];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"UpdateHeading: Heading:%.3f, x:%.3f, y:%.3f, z:%.3f",newHeading.magneticHeading,newHeading.x,newHeading.y,newHeading.z);
}

#pragma mark - setters & getter


#pragma mark - lazy load
- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    return _mapView;
}



@end
