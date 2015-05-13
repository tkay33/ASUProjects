//
//  AddScheduleTableViewController.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/26/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddScheduleTableViewController : UITableViewController


@property (nonatomic, strong) NSMutableArray * unscheduledExerciseNames; //PFObject objects of "Exercise" with only name field

@end
