//
//  ExerciseDetailViewController.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/27/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "ExerciseDetailViewController.h"
#import <Parse/Parse.h>
#import "../../Models/User/User.h"
#import "../../Models/Exercise/Exercise.h"
#import "../../Models/General/Utils.h"

@interface ExerciseDetailViewController ()

@end

@implementation ExerciseDetailViewController

PFObject *exerciseDetails=nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    
    //[self displayEditControls:NO];
    [self loadExerciseDetailsInView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
-(void)displayEditControls:(BOOL)displayFlag
{
    if(displayFlag)
    {
        _editButton.hidden=YES;
        _deleteButton.hidden=YES;
        _saveButton.hidden=NO;
        _cancelButton.hidden=NO;

    }
    else
    {
        _editButton.hidden=NO;
        _deleteButton.hidden=NO;
        _saveButton.hidden=YES;
        _cancelButton.hidden=YES;

    }
}
*/

-(void)loadExerciseDetailsInView
{
    NSError * __autoreleasing error=nil;
    if([User getCurrentUser])
    {
        PFObject *temp=[Exercise getExerciseDetailsForExerciseName:_exerciseTitle.title :&error];
        if(error.code)
        {
            [Utils popupMessage:@"Error connecting to database.."];
            
        }
        else
        {
            exerciseDetails=temp;
            _textView.editable=NO;
            [_textView setText:(NSString *)exerciseDetails[@"description"]];
            [_imageView setImage:[UIImage imageWithData:[(PFFile *)exerciseDetails[@"video"] getData] ]];
            [_durationLabel setText:[(NSNumber *)exerciseDetails[@"duration_in_mins"] stringValue]];

        }
        
    }
    
}

@end
