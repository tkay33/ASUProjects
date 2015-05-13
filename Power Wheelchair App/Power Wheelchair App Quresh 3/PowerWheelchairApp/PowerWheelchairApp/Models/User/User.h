//
//  User.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/1/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>



@interface User : NSObject

+(PFObject *)getCurrentUser;

//login etc.
+(BOOL)intializeUser;

@end
