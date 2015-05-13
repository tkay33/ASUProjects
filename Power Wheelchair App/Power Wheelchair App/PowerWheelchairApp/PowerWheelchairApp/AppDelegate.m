//
//  AppDelegate.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 2/20/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Models/Exercise_Schedule/ExerciseSchedule.h"
#import "Models/General/Utils.h"
#import "Controllers/Exercise_Schedule/ExerciseTimesViewController.h"
#import "Models/User/User.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    [Parse setApplicationId:@"vEtI0mNVAbFn3CE2iI89XLRjd5rro325u60CEWVk"
                  clientKey:@"rfFYDQCg0DUR7adjWgGbkha5hkR2iUspoLn3w708"]; //Parse credentials
    
    if(![User intializeUser])
        [Utils popupMessage:@"Could not login user !"];
            
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) //ios 8 register notifications
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    application.applicationIconBadgeNumber = 0; // Set icon badge number to zero
    
    if([[[UIApplication sharedApplication]scheduledLocalNotifications] count]==0)
    {
        if(![ExerciseSchedule updateExerciseNotifications]) //if error updating and no more notifications left
            [Utils popupMessage:@"Error updating Notifications..Please Press Generate Exercise Notifications from Exercise Times Screen!.."];
        
    }
    else [ExerciseSchedule updateExerciseNotifications];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    application.applicationIconBadgeNumber = 0;
    if(![ExerciseSchedule updateExerciseNotifications] && [[[UIApplication sharedApplication]scheduledLocalNotifications] count]==0) //if error updating and no more notifications left
    {
        [Utils popupMessage:@"Error updating Notifications..Please Press Generate Exercise Notifications from Exercise Times Screen!.."];
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
        [Utils popupMessage:notification.alertBody];
    
    application.applicationIconBadgeNumber = 0;
    if(![ExerciseSchedule updateExerciseNotifications] && [[[UIApplication sharedApplication]scheduledLocalNotifications] count]==0) //if error updating and no more notifications left
    {
        [Utils popupMessage:@"Error updating Notifications..Please Press Generate Exercise Notifications from Exercise Times Screen!.."];
        
    }
    
}


@end
