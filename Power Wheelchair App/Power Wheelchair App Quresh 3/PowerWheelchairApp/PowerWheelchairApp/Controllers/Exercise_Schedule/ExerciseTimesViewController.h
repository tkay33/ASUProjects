//
//  ExerciseTimesTableViewController.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/26/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTimesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *generateNotificationsButton;
@property (nonatomic, strong) NSMutableArray * exerciseSchedules; // PFObject objects of "Exercise" with only name,schedule fields


@end