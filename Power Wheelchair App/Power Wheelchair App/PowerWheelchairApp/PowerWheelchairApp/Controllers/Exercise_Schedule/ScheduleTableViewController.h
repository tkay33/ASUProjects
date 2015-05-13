//
//  ScheduleTableViewController.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/20/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * exerciseSchedules; // PFObject objects of "Exercise" with only name,schedule fields

@end
