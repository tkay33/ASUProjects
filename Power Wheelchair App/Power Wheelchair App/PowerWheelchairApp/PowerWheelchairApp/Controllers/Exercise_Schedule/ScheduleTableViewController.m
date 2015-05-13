//
//  ScheduleTableViewController.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/20/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "ExerciseScheduleMainTabViewController.h"
#import "../../Models/Exercise_Schedule/ExerciseSchedule.h"
#import "../../View_Items/Exercise_Schedule/ScheduleTableViewCell.h"
#import "ScheduleDetailViewController.h"
#import "AddScheduleTableViewController.h"
#import <Parse/Parse.h>
#import "../../Models/General/Utils.h"
#import "../../Models/User/User.h"

@implementation ScheduleTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _exerciseSchedules = [[NSMutableArray alloc] init];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [self reloadData];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _exerciseSchedules.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"scheduleTableCell";
    ScheduleTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    // Configure the cell...    
    long row = [indexPath row]; 
    cell.exerciseLabel.text = (NSString *)[(PFObject *) _exerciseSchedules[row] objectForKey:@"name"];
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showExerciseSchedule"])
    {
        ScheduleDetailViewController *detailViewController =
        [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        ScheduleTableViewCell *selectedCell = (ScheduleTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
        detailViewController.exerciseTitle.title = selectedCell.exerciseLabel.text;
        detailViewController.exerciseScheduleObj=(PFObject *)[(PFObject *)_exerciseSchedules[selectedIndexPath.row] objectForKey:@"current_schedule_id"];
        detailViewController.addExerciseScheduleFlag=false;
        
    }

}

-(void)reloadData {
    
    NSError * __autoreleasing error=nil;
    if([User getCurrentUser])
    {
        NSMutableArray *temp=[ExerciseSchedule getAllExerciseSchedules:&error];
        if(error.code)
        {
            [Utils popupMessage:@"Error connecting to database..Try later or Pull to refresh.."];
            goto end;
        }
        else _exerciseSchedules=temp;
        
        [self.tableView reloadData];
    }
    else [Utils popupMessage:@"Could not login user..Try later or Pull to refresh.."];
    
end:
    if (self.refreshControl)
        [self.refreshControl endRefreshing];
}


@end
