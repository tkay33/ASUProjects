//
//  ScheduleDetailViewController.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/21/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "ExerciseScheduleMainTabViewController.h"
#import "../../Models/Exercise_Schedule/ExerciseSchedule.h"
#import "../../Models/General/Utils.h"
#import "../../Models/General/Constants.h"

@implementation ScheduleDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.daySwitches = [self.daySwitches sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]]; //sort by switch tags 0 for mon,1 for tue etc.
}



- (void)viewWillAppear:(BOOL)animated
{
    
    if(self.addExerciseScheduleFlag)
    {
        self.navigationItem.hidesBackButton = YES;
        [self displayEditControls:YES];
    }
    else [self displayEditControls:NO];
    
    [self loadScheduleDetailsInView];
    return;
    
}



-(void)loadScheduleDetailsInView
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; //already set 24 hr locale thru storyboard
    //timeFormat.locale = twelveHourLocale;
    [timeFormat setDateFormat:EXERCISE_SCHEDULE_TIME_FMT];
    
    if(!_addExerciseScheduleFlag)
    {
        _startTimeLabel.text= (NSString *)_exerciseScheduleObj[@"start_time"];
        _endTimeLabel.text= (NSString *)_exerciseScheduleObj[@"end_time"];
        _frequencyLabel.text=[NSString stringWithFormat:@"%d",[_exerciseScheduleObj[@"frequency_in_mins"] intValue]];
        _frequencyStepper.value=[_exerciseScheduleObj[@"frequency_in_mins"] doubleValue];
        
        BOOL temp;
        for(int i=0;i<[_daySwitches count];i++)
        {
            temp=[[_exerciseScheduleObj[@"days"] objectAtIndex:i] boolValue];
            [(UISwitch *)_daySwitches[i] setOn:temp];
        }
    }
    else
    {
        NSDate *now=[[NSDate alloc] init];
        _startTimeLabel.text= [timeFormat stringFromDate:now];
        _endTimeLabel.text= [timeFormat stringFromDate:now];
        _frequencyLabel.text=[NSString stringWithFormat:@"%d",(int) _frequencyStepper.minimumValue];
        for(int i=0;i<[_daySwitches count];i++)
            [(UISwitch *)_daySwitches[i] setOn:NO];
    }
    
}

-(void)displayEditControls:(BOOL)displayFlag
{
    if(displayFlag)
    {
        _editButton.hidden=YES;
        _deleteButton.hidden=YES;
        _saveButton.hidden=NO;
        _cancelButton.hidden=NO;
        _frequencyStepper.enabled=YES;
        for(UISwitch* dayswitch in _daySwitches)
        {
            dayswitch.enabled=YES;
        }
        _startTimeButton.enabled=YES;
        _endTimeButton.enabled=YES;
    }
    else
    {
        _editButton.hidden=NO;
        _deleteButton.hidden=NO;
        _saveButton.hidden=YES;
        _cancelButton.hidden=YES;
        _frequencyStepper.enabled=NO;
        for(UISwitch* dayswitch in _daySwitches)
        {
            dayswitch.enabled=NO;
        }
        _startTimeButton.enabled=NO;
        _endTimeButton.enabled=NO;
    }
}


- (IBAction)updateFrequecyLabel:(UIStepper *)sender {
    double value = [sender value];
    [_frequencyLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
}



- (IBAction)editExerciseSchedule:(UIButton *)sender {
    self.navigationItem.hidesBackButton = YES;
    [self displayEditControls:YES];
}

- (IBAction)cancelEdit:(UIButton *)sender {
    
    self.navigationItem.hidesBackButton = NO;
    
    if(_addExerciseScheduleFlag)
        [self.navigationController popViewControllerAnimated:TRUE];
    else
    {
        [self loadScheduleDetailsInView];
        [self displayEditControls:NO];
    }
}



- (IBAction)saveExerciseScheduleConfirm:(UIButton *)sender {
    [Utils popupConfirmationWithTitle:@"Save Confirmation" message:@"Confirm Save" delegate:self];
    }


-(BOOL)exerciseScheduleIsValid {
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:EXERCISE_SCHEDULE_TIME_FMT];
    
    if([[timeFormat dateFromString:_startTimeLabel.text] compare:[timeFormat dateFromString:_endTimeLabel.text]] == NSOrderedDescending)
    {
        [Utils popupMessage:@"Start Time should be before End Time!"];
        return false;
    }
    
    bool flag=false;
    for(UISwitch *day in _daySwitches)
    {
        if(day.on)
            flag=true;
    }
    
    if(!flag)
    {
        [Utils popupMessage:@"At least one day should be selected!"];
        return false;
    }
    
    return true;
}

- (void)saveExerciseSchedule {
    
    self.navigationItem.hidesBackButton = YES;
    if(![self exerciseScheduleIsValid])
    {
        self.navigationItem.hidesBackButton = NO;
        return;
    }
    
    PFObject *newExerciseSchedule=[PFObject objectWithClassName:@"Exercise_Schedule"];
    newExerciseSchedule[@"start_time"]=_startTimeLabel.text;
    newExerciseSchedule[@"end_time"]=_endTimeLabel.text;
    newExerciseSchedule[@"frequency_in_mins"]=[NSNumber numberWithDouble:[_frequencyStepper value]];
    BOOL tempDayFlag;
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for(int i=0;i<[_daySwitches count];i++)
    {
        tempDayFlag=((UISwitch *)_daySwitches[i]).on;
        [tempArr addObject:[[NSNumber alloc]initWithBool:tempDayFlag]];
    }
    newExerciseSchedule[@"days"]=tempArr;
    PFObject * tempExerciseScheduleObj;
    if([ExerciseSchedule saveExerciseSchedule:newExerciseSchedule forExerciseName:_exerciseTitle.title])
    {
        NSError * __autoreleasing error=nil;
        tempExerciseScheduleObj= [ExerciseSchedule getExerciseScheduleForExerciseName:_exerciseTitle.title :&error]; //get newExercise schedule in correct pfobject format
        if(tempExerciseScheduleObj)
            _exerciseScheduleObj= [tempExerciseScheduleObj objectForKey:@"current_schedule_id"];
        else if(error.code)
        {
            [Utils popupMessage:@"Schedule saved but could not retrieve updated schedule..Pull to refresh"];
            goto end;
        }
    }
    else {
        [Utils popupMessage:@"Could not save schedule..Please try again.."];
        goto end;
    }
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [ExerciseSchedule updateExerciseNotifications];
    
end:
    if(_addExerciseScheduleFlag)
    {
        //go back 1 views
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        [self loadScheduleDetailsInView];
         self.navigationItem.hidesBackButton = NO;
        [self displayEditControls:NO];
    }
}




- (IBAction)deleteExerciseScheduleConfirm:(UIButton *)sender {
    [Utils popupConfirmationWithTitle:@"Delete Confirmation" message:@"Confirm Delete" delegate:self];
}


- (void)deleteExerciseSchedule
{
    
    if([ExerciseSchedule deleteExerciseScheduleForExerciseName:self.exerciseTitle.title])
    {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [ExerciseSchedule updateExerciseNotifications];
        [self.navigationController popViewControllerAnimated:TRUE]; //go back to previous view        
    }
    
    else [Utils popupMessage:@"Could not delete schedule..Please try again.."];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:@"Delete Confirmation"])
    {
        if (buttonIndex == 1){
            [self deleteExerciseSchedule];
        }
    }
    else if([alertView.title isEqualToString:@"Save Confirmation"])
    {
        if (buttonIndex == 1){
            [self saveExerciseSchedule];
        }
    }
}

- (IBAction)editExerciseTime:(UIButton *)sender {
    if(sender.tag==0) //startTimeButton
        _timeLabelToUpdate=_startTimeLabel;
    else _timeLabelToUpdate=_endTimeLabel;
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:EXERCISE_SCHEDULE_TIME_FMT];
    _datepicker.date=[timeFormat dateFromString:_timeLabelToUpdate.text];
    _datepickerView.hidden=NO;
}


- (IBAction)updateTimeLabel:(UIButton *)sender {
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    //NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    //timeFormat.locale = twelveHourLocale;
    [timeFormat setDateFormat:EXERCISE_SCHEDULE_TIME_FMT];
    _timeLabelToUpdate.text=[NSString stringWithFormat:@"%@",[timeFormat stringFromDate:_datepicker.date]];
        _timeLabelToUpdate=nil;
    _datepickerView.hidden=YES;

}


@end
