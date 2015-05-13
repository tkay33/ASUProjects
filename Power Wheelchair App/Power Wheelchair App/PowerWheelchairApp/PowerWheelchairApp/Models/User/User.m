//
//  User.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/1/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>
#import "../General/Utils.h"    


@implementation User

static PFObject * currentUser;
NSString *const USER_NAME= @"cse591";

+(PFObject *)getCurrentUser {
    if(!currentUser)
    {
        [User intializeUser];
        
    }
    return currentUser;
}


+(BOOL)intializeUser { //add login etc. in future
    NSError * __autoreleasing error=nil;
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:USER_NAME];
    NSArray* result = [query findObjects:&error] ;
    
    if(error || result.count==0)
        return false;
    else
        {
        currentUser = (PFObject *) result[0];
        return true;
        }
}

@end
