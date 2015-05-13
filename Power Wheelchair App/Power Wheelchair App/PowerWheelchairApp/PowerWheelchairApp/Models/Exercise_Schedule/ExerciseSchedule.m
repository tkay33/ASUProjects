//
//  ScheduledExercise.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/21/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "ExerciseSchedule.h"
#import "../General/Utils.h"
#import "../General/Constants.h"
#import "Parse/Parse.h"
#import "../General/Constants.h"
#import "../User/User.h"

//if we want to create sign in to support multiple users, we will have to store User_id after successful sign in as well as cancel All notifications (not reset, since user might have signed in with a previous account and notification count will not be zero)


@implementation ExerciseSchedule
+(NSMutableArray *)getAllExerciseSchedules:(NSError *__autoreleasing *) error
{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query selectKeys:@[@"name", @"current_schedule_id"]];
    [query includeKey:@"current_schedule_id"];
    [query whereKey:@"user_id" equalTo:[User getCurrentUser]];
    [query whereKeyExists:@"current_schedule_id"];
    NSMutableArray* exerciseSchedules = [[query findObjects:error] mutableCopy];
    return exerciseSchedules;
}


+(PFObject *)getExerciseScheduleForExerciseName:(NSString *)exerciseName :(NSError *__autoreleasing *) error
{
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query selectKeys:@[@"name", @"current_schedule_id"]];
    [query includeKey:@"current_schedule_id"];
    [query whereKey:@"user_id" equalTo:[User getCurrentUser]];
    [query whereKey:@"name" equalTo:exerciseName];
    PFObject* exerciseSchedule = [query getFirstObject:error];
    return exerciseSchedule;
}

+(BOOL)saveExerciseSchedule:(PFObject *)schedule forExerciseName:(NSString*)exerciseName
{
    if(!schedule || !exerciseName)
        return false;
    NSError * __autoreleasing error=nil;
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise_Schedule"];
    [query selectKeys:@[@"objectId",@"start_time",@"end_time", @"frequency_in_mins", @"days"]];
    [query whereKey:@"frequency_in_mins" equalTo:schedule[@"frequency_in_mins"]];
    NSArray* exerciseSchedules = [query findObjects:&error];
    if(error.code)
        return false;
    
    BOOL found=NO;
    
    for(PFObject * obj in exerciseSchedules)
    {
        found=NO;
        if([(NSString *)obj[@"start_time"] isEqualToString:(NSString*)schedule[@"start_time"]]
        && [(NSString *)obj[@"end_time"] isEqualToString:(NSString*)schedule[@"end_time"]] )
        {
            found=YES;
            NSArray * arr1=(NSArray *)schedule[@"days"];
            NSArray * arr2=(NSArray *)obj[@"days"];
            for(int i=0;i<arr1.count;i++)
            {
                if([arr1[i] intValue] != [arr2[i] intValue])
                {
                    found=NO;
                    break;
                }
            }
        }
        
        if(found)
        {
            schedule=obj;
            break;
        }
    }
    
    if(!found)
    {
        [schedule save:&error];
        if(error.code)
            return false;
    }
    
    query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"name" equalTo:exerciseName];
    PFObject *exercise=[query getFirstObject];
    exercise[@"current_schedule_id"]=schedule;
    [exercise save:&error];
    if(error.code)
        return false;
    
    return true;

}

+(BOOL)deleteExerciseScheduleForExerciseName:(NSString *)exerciseName
{
    if(!exerciseName)
        return false;
    NSError * __autoreleasing error=nil;
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query whereKey:@"user_id" equalTo:[User getCurrentUser]];
    [query whereKey:@"name" equalTo:exerciseName];
    PFObject* exercise = [query getFirstObject:&error];
    if(error.code)
        return false;
    [exercise removeObjectForKey:@"current_schedule_id"];
    [exercise save:&error];
    if(error.code)
        return false;
    
    return true;
}

+(NSMutableArray *)getUnscheduledExerciseNames:(NSError *__autoreleasing *) error
{    
    PFQuery *query = [PFQuery queryWithClassName:@"Exercise"];
    [query selectKeys:@[@"name"]];
    [query whereKey:@"user_id" equalTo:[User getCurrentUser]];
    [query whereKeyDoesNotExist:@"current_schedule_id"];
    NSMutableArray* unscheduledExerciseNames = [[query findObjects:error] mutableCopy];
    return unscheduledExerciseNames;
}


+(BOOL) updateExerciseNotifications{
    
    int freeNotifications=10; //max 64 local notifications are allowed.. reserve one for update notification
    NSMutableArray *exerciseSchedules = [[NSMutableArray alloc] init];
    
    if([User getCurrentUser])
    {
        NSError * __autoreleasing error=nil;
        NSMutableArray *temp=[ExerciseSchedule getAllExerciseSchedules:&error];
        if(temp)
            exerciseSchedules=temp;
        else if(error.code)
            return false;        
    }
    
    NSDateFormatter *timeFormat=[[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:EXERCISE_SCHEDULE_TIME_FMT];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *currDateTime=[[NSDate alloc] init]; //now
    NSMutableDictionary *tempNotificationDict= [[ NSMutableDictionary alloc] init];
    NSMutableArray *notificationsArray= [[NSMutableArray alloc] init];
    NSMutableDictionary *exerciseNotificationsCount= [[NSMutableDictionary alloc] init];
    bool isFirstIteration=true;
    
    if(exerciseSchedules.count > 0)
    {
        while(tempNotificationDict.count < freeNotifications)
        {
            for(PFObject *exercise in exerciseSchedules)
            {
                PFObject  *exerciseSchedule=exercise[@"current_schedule_id"];
                NSDate *exerciseStartDateTime= [self dateFromTimeString:exerciseSchedule[@"start_time"] AndDate:currDateTime TimeFormat:timeFormat Calendar:calendar];
                NSDate *exerciseEndDateTime= [self dateFromTimeString:exerciseSchedule[@"end_time"] AndDate:currDateTime TimeFormat:timeFormat Calendar:calendar];
                int freqInSecs=[exerciseSchedule[@"frequency_in_mins"] intValue] * 60;
                
                if(isFirstIteration && [currDateTime compare:exerciseStartDateTime] == NSOrderedDescending) //now > exercise_start_time
                {
                    NSTimeInterval timediff= [currDateTime timeIntervalSinceDate:exerciseStartDateTime];
                    exerciseStartDateTime= [exerciseStartDateTime dateByAddingTimeInterval:freqInSecs * ceil(timediff/freqInSecs)];
                }
                
                if([[(NSArray *)exerciseSchedule[@"days"] objectAtIndex:[self getDayFromDate:currDateTime]] boolValue])
                {
                    if(!exerciseNotificationsCount[exercise[@"name"]])
                        [exerciseNotificationsCount setObject:@0 forKey:exercise[@"name"]];
                    
                    while([exerciseStartDateTime compare:exerciseEndDateTime] != NSOrderedDescending && [exerciseNotificationsCount[exercise[@"name"]] intValue] < freeNotifications)
                    {
                        if(tempNotificationDict[exerciseStartDateTime])
                        {
                            [(NSMutableString *)tempNotificationDict[exerciseStartDateTime] appendString:@"," ];
                            [(NSMutableString *)tempNotificationDict[exerciseStartDateTime] appendString:exercise[@"name"]];
                            
                        }
                        else{
                            [tempNotificationDict setObject:[@"Time for Exercise " mutableCopy] forKey:exerciseStartDateTime];
                            [(NSMutableString *)tempNotificationDict[exerciseStartDateTime] appendString:exercise[@"name"]];
                        }
                        exerciseStartDateTime=[exerciseStartDateTime dateByAddingTimeInterval:freqInSecs];
                        exerciseNotificationsCount[exercise[@"name"]] = [NSNumber numberWithInt:[(NSNumber *) exerciseNotificationsCount[exercise[@"name"]] intValue] +1];
                    }
                }
                
            }
            isFirstIteration=false;
            currDateTime=[currDateTime dateByAddingTimeInterval:24*60*60]; //next day
        }
    }
    
    NSArray *sortedKeys=[[tempNotificationDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    UILocalNotification *localNotification;
    for(NSDate *key in sortedKeys)
    {
        localNotification=[[UILocalNotification alloc] init];
        [(NSMutableString *)tempNotificationDict[key] appendString:@" ..\nClick here/Open App to update future notifications!"];
        localNotification.alertBody=tempNotificationDict[key];
        localNotification.fireDate = key;
        localNotification.alertAction = @"Exercise Time!";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [notificationsArray addObject:localNotification];
    }
    
    if(notificationsArray.count > 0)
    {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].scheduledLocalNotifications=[[[NSArray alloc] init] arrayByAddingObjectsFromArray:[notificationsArray subarrayWithRange:NSMakeRange(0, freeNotifications)]];
    }
    
    return true;
}

/*Debugging [self checkNotifications:[notificationsArray subarrayWithRange:NSMakeRange(0, freeNotifications)]];
+(void)checkNotifications:(NSArray *) arr{
   // NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    //[fmt setTimeZone:[NSTimeZone defaultTimeZone]];
    for(UILocalNotification * x in arr)
    {
        NSDate *temp=x.fireDate;
    }
}
*/

+(int)getDayFromDate:(NSDate *)date {
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; //coz different locales may have diff start day mon or sun
    NSDateFormatter *dayFormat= [[NSDateFormatter alloc]init];
    [dayFormat setDateFormat:@"c"];
    dayFormat.locale = locale;
    return [[dayFormat stringFromDate:date] intValue] - 1; //so that starts at 0
                    
}


/*
+(BOOL) cancelAllExerciseNotifications {
    

    if([ExerciseSchedule saveLastScheduledNotificationTime:[[NSDate alloc] init]]) //save 'now'
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        return true;
    }
    return false;
}
*/

/*
+(PFObject *)getLastScheduledNotificationTimeObject:(NSError *__autoreleasing *) error {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Last_Scheduled_Exercise_Notification_DateTime"];
    [query whereKey:@"device_id" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSArray* results = [query findObjects:error];
    if(results.count>0)
        return (PFObject *)results[0];
    
    if(*error)
        return nil;
    
    PFObject *obj=[PFObject objectWithClassName:@"Last_Scheduled_Exercise_Notification_DateTime"];
    obj[@"device_id"]=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    obj[@"date_time"]=[[NSDate alloc] init];
    [obj save:error];
    if(*error)
        return nil;
    
    return obj;
}
*/

/*
+(NSDate *) getLastScheduledNotificationTime {
    NSError * __autoreleasing error=nil;
    PFObject* result = [self getLastScheduledNotificationTimeObject:&error];
    if(error)
        return nil;
    return (NSDate *)result[@"date_time"];
}
*/

/*
+(BOOL) saveLastScheduledNotificationTime:(NSDate *) dateTime {
    
    if(!dateTime)
        return false;
    NSError * __autoreleasing error=nil;
    PFObject* result = [self getLastScheduledNotificationTimeObject:&error];
    if(error)
        return false;
    result[@"date_time"]=dateTime;
    [result save:&error];
    if(error)
        return false;
    
    return true;
}
*/

+(NSDate *) dateFromTimeString:(NSString *) timeString AndDate:(NSDate*) date TimeFormat:(NSDateFormatter *) timeFormat Calendar:(NSCalendar *) calendar {
    
    NSDateComponents *dateComponents=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitTimeZone fromDate:date];
    NSDate * time=[timeFormat dateFromString:timeString];
    NSDateComponents* timeComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:time];
    [timeComponents setYear: [dateComponents year]];
    [timeComponents setMonth: [dateComponents month]];
    [timeComponents setDay: [dateComponents day]];
    [timeComponents setTimeZone:[dateComponents timeZone]];
    return [calendar dateFromComponents:timeComponents];
}

/*
+(void)disableExerciseNotifications {
    
    notificationsEnabled =false;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}
*/
        

@end
