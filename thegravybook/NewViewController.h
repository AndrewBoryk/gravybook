//
//  NewViewController.h
//  thegravybook
//
//  Created by Andrew Boryk on 6/29/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobViewController.h"

@interface NewViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>

//Variables
@property (strong, nonatomic) NSMutableArray *arrayOfJobs;
@property (strong, nonatomic) NSUserDefaults *defaulter;

//Properties
@property (strong, nonatomic) IBOutlet UITextField *roNumber;
@property (strong, nonatomic) IBOutlet UILabel *roDate;
@property (strong, nonatomic) IBOutlet UIButton *changeDateButton;
@property (strong, nonatomic) IBOutlet UITextField *accHours;
@property (strong, nonatomic) IBOutlet UITextView *comments;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addJobs;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPics;

//Date View Properties
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;



//Actions
- (IBAction)changeDateAction:(id)sender;
- (IBAction)confirmDateAction:(id)sender;
- (IBAction)pickerAction:(id)sender;
- (IBAction)addPicAction:(id)sender;
- (IBAction)addJobsAction:(id)sender;


@end
