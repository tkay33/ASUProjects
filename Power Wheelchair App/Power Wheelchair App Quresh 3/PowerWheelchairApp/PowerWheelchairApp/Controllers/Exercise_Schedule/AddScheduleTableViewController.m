//
//  AddScheduleTableViewController.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/26/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "../../View_Items/Exercise_Schedule/AddScheduleTableViewCell.h"
#import "AddScheduleTableViewController.h"
#import "ScheduleDetailViewController.h"
#import "ExerciseScheduleMainTabViewController.h"
#import "../../Models/General/Utils.h"
#import "../../Models/Exercise_Schedule/ExerciseSchedule.h"
#import "../../Models/User/User.h"

@interface AddScheduleTableViewController ()

@end

@implementation AddScheduleTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _unscheduledExerciseNames = [[NSMutableArray alloc] init];
    
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
    return _unscheduledExerciseNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"addScheduleTableCell";
    AddScheduleTableViewCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier
                                   forIndexPath:indexPath];
    // Configure the cell...
    long row = [indexPath row]; 
    cell.exerciseLabel.text = [(PFObject *)_unscheduledExerciseNames[row] objectForKey:@"name"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ScheduleDetailViewController *detailViewController =
    [segue destinationViewController];
    detailViewController.addExerciseScheduleFlag=true;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    detailViewController.exerciseScheduleObj=nil;
    AddScheduleTableViewCell *selectedCell = (AddScheduleTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    detailViewController.exerciseTitle.title = selectedCell.exerciseLabel.text;
    
}

-(void)reloadData {
    
    NSError * __autoreleasing error=nil;
    if([User getCurrentUser])
    {
        NSMutableArray *temp=[ExerciseSchedule getUnscheduledExerciseNames:&error];
        
        if(error.code)
        {
            [Utils popupMessage:@"Error connecting to database..Try later or Pull to refresh.."];
            goto end;
        }
        else _unscheduledExerciseNames=temp;
        [self.tableView reloadData];
    }
    else [Utils popupMessage:@"Could not login user..Try later or Pull to refresh.."];
 
end:
    if (self.refreshControl)
        [self.refreshControl endRefreshing];
}

@end
