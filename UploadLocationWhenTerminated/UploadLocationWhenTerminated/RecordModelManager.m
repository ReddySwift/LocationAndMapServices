//
//  RecordModelManager.m
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import "RecordModelManager.h"
#import <MJExtension/MJExtension.h>
#import <UIKit/UIKit.h>

@implementation RecordModelManager

+ (instancetype)sharedManager {
    static RecordModelManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RecordModelManager alloc] init];
        manager.records = [self loadLocalRecords];
    });
    return manager;
}

+ (NSMutableArray *)loadLocalRecords {
    NSArray *array = [NSArray arrayWithContentsOfFile:[self localRecordPath]];
    if (!array) {
        array = [[NSArray alloc] init];
    }
    NSArray *models = [LocationRecord mj_objectArrayWithKeyValuesArray:array];
    return [NSMutableArray arrayWithArray:models];
}

- (void)saveObjects {
    NSArray *tempArr = [LocationRecord mj_keyValuesArrayWithObjectArray:self.records];
    [tempArr writeToFile:[RecordModelManager localRecordPath] atomically:YES];
}

- (void)addRecordWithLocation:(CLLocation *)location {
    NSString *title;
    switch ([[UIApplication sharedApplication] applicationState]) {
        case UIApplicationStateActive:
            title = @"Active";
            break;
        case UIApplicationStateInactive:
            title = @"Inactive";
            break;
        case UIApplicationStateBackground:
            title = @"Background";
            break;
    }
    [self addRecordWithLocation:location identifier:title];
}

- (void)addRecordWithLocation:(CLLocation *)location identifier:(NSString *)identifier {
    LocationRecord *record = [[LocationRecord alloc] init];
    record.date = [NSDate date];
    record.title = [NSString stringWithFormat:@"%@, coordinate: la = %.5f, long = %.5f ",identifier,location.coordinate.latitude,location.coordinate.longitude];
    [self.records insertObject:record atIndex:0];
    [self saveObjects];
}

+ (NSString *)localRecordPath {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *localRecordPath = [NSString stringWithFormat:@"%@/temp.plist", documentsPath];
    return localRecordPath;
}
@end
