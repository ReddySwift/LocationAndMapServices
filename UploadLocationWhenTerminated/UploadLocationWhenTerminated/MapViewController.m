//
//  ViewController.m
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <Masonry/Masonry.h>

@interface MapViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation MapViewController


#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialViews];
}

- (void)updateViewConstraints {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

#pragma mark - private
- (void)initialViews {
    [self.view addSubview:self.mapView];
}

#pragma mark - public
#pragma mark - event respond
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    if (mode != MKUserTrackingModeFollow) {
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
        MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.5, 0.5));
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark - lazy load
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        _mapView.delegate = self;
    }
    return _mapView;
}

#pragma mark - setters & getter
@end
