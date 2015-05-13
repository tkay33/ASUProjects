//
//  AddExerciseViewController.h
//  Exercises
//
//  Created by tkanchar on 4/28/15.
//  Copyright (c) 2015 tkanchar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExerciseViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imgToUpload;
@property (nonatomic, strong) IBOutlet UITextField *exerciseName;
@property (nonatomic, strong) IBOutlet UITextView *exerciseDescription;
@property (nonatomic, strong) IBOutlet UITextField *durationLabel;

-(IBAction)selectPicturePressed:(id)sender;

@end
