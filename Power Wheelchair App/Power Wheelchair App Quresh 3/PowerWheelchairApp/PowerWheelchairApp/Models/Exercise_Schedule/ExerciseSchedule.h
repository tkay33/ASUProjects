//
//  ScheduledExercise.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/21/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ExerciseSchedule : NSObject

+(NSMutableArray *)getAllExerciseSchedules:(NSError *__autoreleasing *) error;
+(PFObject *)getExerciseScheduleForExerciseName:(NSString *)exerciseName :(NSError *__autoreleasing *) error;
+(NSMutableArray *)getUnscheduledExerciseNames:(NSError *__autoreleasing *) error;
+(BOOL)saveExerciseSchedule:(PFObject *)schedule forExerciseName:(NSString*)exerciseName;
+(BOOL)deleteExerciseScheduleForExerciseName:(NSString *)exerciseName;
+(BOOL) updateExerciseNotifications;
//+(BOOL) cancelAllExerciseNotifications;
//+(void)disableExerciseNotifications;
//+(NSDate *) getLastScheduledNotificationTime;
//+(BOOL) saveLastScheduledNotificationTime:(NSDate *) dateTime;
+(NSDate *) dateFromTimeString:(NSString *) timeString AndDate:(NSDate*) date TimeFormat:(NSDateFormatter *) timeFormat Calendar:(NSCalendar *) calendar;
@end
