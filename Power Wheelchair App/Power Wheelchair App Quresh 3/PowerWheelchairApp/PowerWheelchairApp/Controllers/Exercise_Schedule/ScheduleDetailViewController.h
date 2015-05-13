//
//  ScheduleDetailViewController.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/21/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ScheduleDetailViewController : UIViewController<UIAlertViewDelegate,UIPopoverControllerDelegate>

@property (assign,nonatomic) BOOL addExerciseScheduleFlag;
@property (weak,nonatomic) PFObject *exerciseScheduleObj;
@property (weak, nonatomic) IBOutlet UINavigationItem *exerciseTitle;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *daySwitches;
@property (weak, nonatomic) IBOutlet UIStepper *frequencyStepper;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) UILabel *timeLabelToUpdate;
@property (weak, nonatomic) IBOutlet UIView *datepickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;

@end
