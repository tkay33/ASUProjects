//
//  Exercise.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/27/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "Exercise.h"
#import "Parse/Parse.h"
#import "../User/User.h"

@implementation Exercise

+(NSMutableArray *)getExerciseNames:(NSError *__autoreleasing *) error
{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query selectKeys:@[@"name"]];
    [query whereKey:@"user_id" equalTo:[User getCurrentUser]];
    NSMutableArray* exerciseNames = [[query findObjects:error] mutableCopy];
    return exerciseNames;
}


+(PFObject *)getExerciseDetailsForExerciseName:(NSString *)exerciseName :(NSError *__autoreleasing *) error
{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"user_id" equalTo:[User getCurrentUser]];
    [query whereKey:@"name" equalTo:exerciseName];
    PFObject* exerciseDetails = [query getFirstObject:error];
    return exerciseDetails;
}

@end
