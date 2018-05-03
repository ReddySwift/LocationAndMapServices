//
//  RecordModelManager.h
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationRecord.h"
#import <CoreLocation/CoreLocation.h>

@interface RecordModelManager : NSObject

@property (nonatomic, strong) NSMutableArray<LocationRecord *> *records;

+ (instancetype)sharedManager;
- (void)saveObjects;
- (void)addRecordWithLocation:(CLLocation *)location;
- (void)addRecordWithLocation:(CLLocation *)location identifier:(NSString *)identifier;

@end
