//
//  Exercise.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/27/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Exercise : NSObject

+(NSMutableArray *)getExerciseNames:(NSError *__autoreleasing *) error;
+(PFObject *)getExerciseDetailsForExerciseName:(NSString *)exerciseName :(NSError *__autoreleasing *) error;
@end
