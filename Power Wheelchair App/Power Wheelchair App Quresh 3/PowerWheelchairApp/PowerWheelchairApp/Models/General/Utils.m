//
//  Utils.m
//  PowerWheelchairApp
//
//  Created by qlokhand on 3/9/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation Utils

+(void) popupMessage:(NSString *) msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
    [alert show];
}

+(void)popupConfirmationWithTitle:(NSString *)title message:(NSString *)msg delegate:(id) d {
    
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:d cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
[alert show];
    
}

@end
