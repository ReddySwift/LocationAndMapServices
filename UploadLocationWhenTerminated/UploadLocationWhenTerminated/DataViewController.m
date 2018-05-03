//
//  DataViewController.m
//  UploadLocationWhenTerminated
//
//  Created by chenjie on 2018/4/13.
//  Copyright © 2018年 starrythrone. All rights reserved.
//

#import "DataViewController.h"
#import "LocationRecord.h"
#import "LocationService.h"
#import "RecordModelManager.h"

@interface DataViewController ()

@property (nonatomic, strong) NSMutableArray<LocationRecord *> *locationRecords;


@end

@implementation DataViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self configureDefaultData];
    [self addNotifications];
}

- (void)dealloc {
    [self removeNotifications];
}



#pragma mark - private
- (void)setupViews {
    self.tableView.rowHeight = 50;
}

- (void)configureDefaultData {
    self.locationRecords = [RecordModelManager sharedManager].records;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdated) name:LocationServiceDidUpdateLocation object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

#pragma mark - public
#pragma mark - event respond
- (void)receiveLocationUpdated {
    self.locationRecords = [RecordModelManager sharedManager].records;
    [self.tableView reloadData];
}

#pragma mark - UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    LocationRecord *record = [self.locationRecords objectAtIndex:indexPath.row];
    cell.textLabel.text = record.date.description;
    cell.detailTextLabel.text = record.title;
    
    if ([record.title containsString:@"FinishLaunching"] || [record.title containsString:@"EnterForeground"] || [record.title containsString:@"BecomeActive"] || [record.title containsString:@"ResignActive"] || [record.title containsString:@"EnterBackground"] || [record.title containsString:@"WillTerminate"] ) {
        cell.textLabel.textColor = [UIColor redColor];
    } else if ([record.title containsString:@"Active"]) {
        cell.textLabel.textColor = [UIColor blackColor];
    } else if ([record.title containsString:@"Inactive"]) {
        cell.textLabel.textColor = [UIColor brownColor];
    } else if ([record.title containsString:@"Background"]) {
        cell.textLabel.textColor = [UIColor grayColor];
    } else{
        cell.textLabel.textColor = [UIColor greenColor];
    }
    
    
    
    
    return cell;
}

#pragma mark - lazy load
#pragma mark - setters & getter


@end
