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
@property (nonatomic, strong) UILabel *destiLabel;
@property (nonatomic, strong) UIButton *naviButton;



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
    
    [_destiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
    }];
    
    [_naviButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(80);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [super updateViewConstraints];
}

#pragma mark - public


#pragma mark - private
- (void)confirgureViews {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.destiLabel];
    [self.view addSubview:self.naviButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)configureDefaultData {
}

- (void)configureLocationService {
    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.manager requestAlwaysAuthorization];
    }
}

- (void)navigateToAddress:(NSString *)address {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return;
        }
        CLPlacemark *destiPlace = placemarks.lastObject;
        MKPlacemark *destiMark = [[MKPlacemark alloc] initWithPlacemark:destiPlace];
        MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destiMark];
        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];

        MKDirectionsRequest *request = [MKDirectionsRequest new];
        request.source = sourceItem;
        request.destination = destinationItem;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            if (response.routes.count == 0 || error) {
                return;
            }
            for (MKRoute *route in response.routes) {
                MKPolyline *polyline = route.polyline;
                [self.mapView addOverlay:polyline];
            }
        }];
    }];
}

#pragma mark - event respond
- (void)navigationButtonClicked:(UIButton *)sender {
    [self navigateToAddress:@"中国地质大学"];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(mapView.userLocation.location.coordinate, span);
        [self.mapView setRegion:region animated:YES];
    });
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.strokeColor = [UIColor blueColor];
    return polylineRender;
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
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UILabel *)destiLabel {
    if (!_destiLabel) {
        _destiLabel = [[UILabel alloc] init];
        _destiLabel.text = @"Destination:中国地质大学";
    }
    return _destiLabel;
}

- (UIButton *)naviButton {
    if (!_naviButton) {
        _naviButton = [[UIButton alloc] init];
        [_naviButton setTitle:@"Nivigation" forState:UIControlStateNormal];
        [_naviButton addTarget:self action:@selector(navigationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_naviButton setBackgroundColor:[UIColor orangeColor]];
    }
    return _naviButton;
}


@end
