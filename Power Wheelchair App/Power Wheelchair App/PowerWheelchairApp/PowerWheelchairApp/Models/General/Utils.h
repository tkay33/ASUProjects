//
//  Utils.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 3/9/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(void)popupMessage:(NSString *) msg;
+(void)popupConfirmationWithTitle:(NSString *)title message:(NSString *)msg delegate:(id) d;

@end
