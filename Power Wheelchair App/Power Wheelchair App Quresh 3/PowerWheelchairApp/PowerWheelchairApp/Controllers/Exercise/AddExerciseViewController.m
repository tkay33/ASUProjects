//
//  AddExerciseViewController.m
//  Exercises
//
//  Created by tkanchar on 4/28/15.
//  Copyright (c) 2015 tkanchar. All rights reserved.
//

#import "AddExerciseViewController.h"
#import <Parse/Parse.h>
#import "../../Models/User/User.h"

@interface AddExerciseViewController  ()

-(void)showErrorView:(NSString *)errorMsg;

@end

@implementation AddExerciseViewController

@synthesize imgToUpload = _imgToUpload;
@synthesize exerciseName = _exerciseName;
@synthesize exerciseDescription = _exerciseDescription;
@synthesize durationLabel = _durationLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imgToUpload = nil;
    self.exerciseName = nil;
    self.exerciseDescription = nil;
    self.durationLabel = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)selectPicturePressed:(id)sender
{
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.allowsEditing = YES;
    
    [self presentViewController:imgPicker animated:YES completion:NULL];
}

#pragma mark UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgToUpload.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark Error View

- (IBAction)savePressed:(id)sender {
        
        //Disable the send button until we are ready
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        
        //Place the loading spinner
        UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
        [loadingSpinner startAnimating];
        
        [self.view addSubview:loadingSpinner];
        
        
        //Upload a new picture
        NSData *pictureData = UIImagePNGRepresentation(self.imgToUpload.image);
    
        PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                PFObject *user= [User getCurrentUser];
                //Add the image to the object, and add the comments, the user, and the geolocation (fake)
                PFObject *exerciseObject = [PFObject objectWithClassName:@"Exercise"];
                [exerciseObject setObject:user forKey:@"user_id"];
                [exerciseObject setObject:file forKey:@"video"];
                //[imageObject setObject:[PFUser currentUser].username forKey:KEY_USER]; set current user
                [exerciseObject setObject:self.exerciseName.text forKey:@"name"];
                [exerciseObject setObject:self.exerciseDescription.text forKey:@"description"];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *myNumber = [f numberFromString:self.durationLabel.text];
                
                [exerciseObject setObject: myNumber forKey:@"duration_in_mins"];
                [exerciseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded){
                        //Go back to the wall
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        [self showErrorView:errorString];
                    }
                }];
            }
            else{
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [self showErrorView:errorString];
            }
            
            [loadingSpinner stopAnimating];
            [loadingSpinner removeFromSuperview];       
            
        } progressBlock:^(int percentDone) {
            
        }];
    
}

-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
