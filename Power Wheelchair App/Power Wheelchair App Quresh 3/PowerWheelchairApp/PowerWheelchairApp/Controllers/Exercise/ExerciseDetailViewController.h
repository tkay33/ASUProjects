//
//  ExerciseDetailViewController.h
//  PowerWheelchairApp
//
//  Created by qlokhand on 4/27/15.
//  Copyright (c) 2015 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *exerciseTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
