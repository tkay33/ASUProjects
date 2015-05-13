//
//  ExerciseTableViewController.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/27/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "ExerciseTableViewController.h"
#import "ExerciseDetailViewController.h"
#import "../../View_Items/Exercise/ExerciseTableViewCell.h"
#import "../../Models/General/Utils.h"
#import "../../Models/Exercise/Exercise.h"
#import "../../Models/User/User.h"

@interface ExerciseTableViewController ()

@end

@implementation ExerciseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _exerciseNames = [[NSMutableArray alloc] init];
    
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
    return _exerciseNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"exerciseTableCell";
    ExerciseTableViewCell *cell = [tableView
                                      dequeueReusableCellWithIdentifier:CellIdentifier
                                      forIndexPath:indexPath];
    // Configure the cell...
    long row = [indexPath row];
    cell.exerciseLabel.text = [(PFObject *)_exerciseNames[row] objectForKey:@"name"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showExerciseDetail"])
    {
        ExerciseDetailViewController *detailViewController =
        [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        ExerciseTableViewCell *selectedCell = (ExerciseTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
        detailViewController.exerciseTitle.title = selectedCell.exerciseLabel.text;
        NSString * x=detailViewController.exerciseTitle.title;
    }
    
}

- (IBAction)refreshData:(UIButton *)sender {
    if([self reloadData])
        [Utils popupMessage:@"Exercises Refreshed!"];
    else [Utils popupMessage:@"Exercises could not be Refreshed!"];
    
}

-(BOOL)reloadData {
    
    NSError * __autoreleasing error=nil;
    if([User getCurrentUser])
    {
        NSMutableArray *temp=[Exercise getExerciseNames:&error];
        
        if(error.code)
        {
            [Utils popupMessage:@"Error connecting to database..Try later or press refresh.."];
            return false;
        }
        else _exerciseNames=temp;
        
        [self.tableView reloadData];
    }
    else
    {
        [Utils popupMessage:@"Could not login user..Try later or Pull to refresh.."];
        return false;

    }
    return true;
}


@end
