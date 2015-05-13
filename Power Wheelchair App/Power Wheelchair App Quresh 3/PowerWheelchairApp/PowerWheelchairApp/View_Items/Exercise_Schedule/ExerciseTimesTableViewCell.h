//
//  ExerciseTimesTableViewCell.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/26/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTimesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *exerciseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@end
