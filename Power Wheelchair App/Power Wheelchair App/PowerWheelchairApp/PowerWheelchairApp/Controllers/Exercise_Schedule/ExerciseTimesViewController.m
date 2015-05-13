//
//  ExerciseTimesTableViewController.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/26/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "Parse/Parse.h"
#import "ExerciseTimesViewController.h"
#import "ExerciseScheduleMainTabViewController.h"
#import "../../View_Items/Exercise_Schedule/ExerciseTimesTableViewCell.h"
#import "../../Models/General/Utils.h"
#import "../../Models/General/Constants.h"
#import "../../Models/User/User.h"
#import "../../Models/Exercise_Schedule/ExerciseSchedule.h"


@interface ExerciseTimesViewController ()

@end

@implementation ExerciseTimesViewController


NSDateFormatter *_dayFormat, *_timeFormat, *_displayFormat;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDateFormatters];
    _exerciseSchedules = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)viewWillAppear:(BOOL)animated {
    
    [self reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _exerciseSchedules.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"exerciseTimesTableCell";
    ExerciseTimesTableViewCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier
                                   forIndexPath:indexPath];
    // Configure the cell...
    long row = [indexPath row];
    if(row!=0)
    {
        cell.exerciseNameLabel.text = [_exerciseSchedules[row-1] objectForKey:@"name"];
        PFObject * exerciseSchedule=[_exerciseSchedules[row-1] objectForKey:@"current_schedule_id"];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate *now=[[NSDate alloc ] init];
        NSDate * startTime=[ExerciseSchedule dateFromTimeString:exerciseSchedule[@"start_time"]	AndDate:now TimeFormat:_timeFormat Calendar:calendar];
        NSDate * endTime=[ExerciseSchedule dateFromTimeString:exerciseSchedule[@"end_time"]	AndDate:now TimeFormat:_timeFormat Calendar:calendar];
        NSArray *days= exerciseSchedule[@"days"];
        int todaysDay=[[_dayFormat stringFromDate:now] intValue] - 1; //so that starts at 0
        
        if([now compare:startTime] == NSOrderedAscending) //now < startTime
        {
            cell.lastTimeLabel.text=[_displayFormat stringFromDate:[self getLastOrNextTime:YES forDay:todaysDay daysArray:days startTime:startTime endTime:endTime]];
            if([days[todaysDay] boolValue])
                cell.nextTimeLabel.text=[_displayFormat stringFromDate:startTime];
            else cell.nextTimeLabel.text=[_displayFormat stringFromDate:[self getLastOrNextTime:NO forDay:todaysDay daysArray:days startTime:startTime endTime:endTime]];
        }
        
        else if([now compare:endTime] == NSOrderedDescending) //now > endTime
        {
            if([days[todaysDay] boolValue])
                cell.lastTimeLabel.text=[_displayFormat stringFromDate:endTime];
            else cell.lastTimeLabel.text=[_displayFormat stringFromDate:[self getLastOrNextTime:YES forDay:todaysDay daysArray:days startTime:startTime endTime:endTime]];
            cell.nextTimeLabel.text=[_displayFormat stringFromDate:[self getLastOrNextTime:NO forDay:todaysDay daysArray:days startTime:startTime endTime:endTime]];
        }
        
        else //startTime <= now <= endTime
        {
            NSTimeInterval diff= [now timeIntervalSinceDate:startTime];
            int freqInSecs=[exerciseSchedule[@"frequency_in_mins"] intValue] * 60;
            NSDate *lastTime= [startTime dateByAddingTimeInterval:freqInSecs *(int)(diff/freqInSecs)];
            NSDate *nextTime= [lastTime dateByAddingTimeInterval:freqInSecs];
            
            if([days[todaysDay] boolValue])
                cell.lastTimeLabel.text=[_displayFormat stringFromDate:lastTime];
            else cell.lastTimeLabel.text=[_displayFormat stringFromDate:[self getLastOrNextTime:YES forDay:todaysDay daysArray:days startTime:startTime endTime:endTime]];
            
            if([days[todaysDay] boolValue] && ([nextTime compare:endTime]== NSOrderedAscending || [nextTime isEqualToDate:endTime])) //nextTime <= endTime
               cell.nextTimeLabel.text= [_displayFormat stringFromDate:nextTime];
            else cell.nextTimeLabel.text=[_displayFormat stringFromDate:[self getLastOrNextTime:NO forDay:todaysDay daysArray:days startTime:startTime endTime:endTime]];
        }
    }
    
    else {
        cell.exerciseNameLabel.text = @"Exercise Name";
        cell.nextTimeLabel.text= @"Next Time";
        cell.lastTimeLabel.text=@"Last Time";
        
        cell.exerciseNameLabel.textAlignment = NSTextAlignmentCenter;
        cell.nextTimeLabel.textAlignment = NSTextAlignmentCenter;
        cell.lastTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.exerciseNameLabel.font=[UIFont boldSystemFontOfSize:10];
        cell.nextTimeLabel.font=[UIFont boldSystemFontOfSize:10];
        cell.lastTimeLabel.font=[UIFont boldSystemFontOfSize:10];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) initializeDateFormatters {
    //date formatters
    NSLocale *_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; //coz different locales may have diff start day mon or sun
    _dayFormat= [[NSDateFormatter alloc]init];
    [_dayFormat setDateFormat:@"c"]; //get day number.. sunday is start for us
    _dayFormat.locale = _locale;
    _timeFormat = [[NSDateFormatter alloc]init];
    [_timeFormat setDateFormat:EXERCISE_SCHEDULE_TIME_FMT];
    _displayFormat = [[NSDateFormatter alloc]init];
    [_displayFormat setDateFormat:@"cccccc MM/dd h:mm a"];
}
                
-(NSDate *)getLastOrNextTime:(BOOL)lastFlag forDay:(int) today daysArray:(NSArray *)days startTime:(NSDate *) startTime endTime:(NSDate *)endTime {
    
    int count=0;
    if(lastFlag)
    {
        int i=today;
        do
        {   count++;
            i=(i-1<0)? 6 : i-1;
            if([days[i] boolValue])
                return [endTime dateByAddingTimeInterval:-count * 86400] ;
        }while(i!=today);
    }
    else{
        
        int i=today;
        do
        {   count++;
            i=(i+1)%7;
            if([days[i] boolValue])
                return [startTime dateByAddingTimeInterval:count * 86400] ;
        }while(i!=today);
    }
    
    return nil;
}


- (IBAction)refreshData:(UIButton *)sender {
    if([self reloadData])
        [Utils popupMessage:@"Data Refreshed!"];
    else [Utils popupMessage:@"Data not Refreshed!"];
    
}


-(BOOL)reloadData {
    
    NSError * __autoreleasing error=nil;
    if([User getCurrentUser])
    {
        NSMutableArray *temp=[ExerciseSchedule getAllExerciseSchedules:&error];
        if(error.code)
        {
            [Utils popupMessage:@"Error connecting to database..Try later or Press Refresh! "];
            return false;
        }
        else _exerciseSchedules=temp; //nil or nsarray
        
        [_tableView reloadData];
    }
    else
    {
        [Utils popupMessage:@"Could not login user..Try later or Press Refresh! "];
        return false;
    }
    return true;
}


- (IBAction)generateNotifications:(UIButton *)sender {
    
    
    if(![ExerciseSchedule updateExerciseNotifications])
        [Utils popupMessage:@"Could not generate notifications! Try Again later.."];
    else [Utils popupMessage:@"Exercise notifications generated!"];
}

@end
