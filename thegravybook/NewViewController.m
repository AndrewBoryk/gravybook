//
//  NewViewController.m
//  thegravybook
//
//  Created by Andrew Boryk on 6/29/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()

@end

NSDate *savedDate;

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaulter = [NSUserDefaults standardUserDefaults];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
//    UIBarButtonItem *photoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(photoAction:)];
    [self.dateView setAlpha:0];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"MM/dd/YYYY"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    self.roDate.text = date_String;
    savedDate = [NSDate date];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.navigationItem setRightBarButtonItems:@[doneButton]];
    self.arrayOfJobs = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    [self.roNumber becomeFirstResponder];
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
//    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    
    self.keyboardSpace.constant = keyboardFrame.size.height+8;
}

- (void)doneAction:(id)sender{
    if (![self.roNumber.text isEqualToString:@""]) {
        if ([self.arrayOfJobs count] > 0) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.roNumber.text, @"ro#", savedDate, @"date",self.arrayOfJobs, @"jobs", nil];
            if ([self.comments.text isEqualToString: @""]) {
                [dict setObject:self.comments.text forKey:@"comments"];
            }
            NSLog(@"Dict: %@", dict);
            NSMutableArray *temp = [[self.defaulter objectForKey:@"ro"] mutableCopy];
            NSLog(@"Temp: %@", temp);
            [temp addObject:dict];
            NSLog(@"Now: %@", temp);
            [self.defaulter setObject:temp forKey:@"ro"];
            [self.defaulter synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please add jobs to this repair order." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all required fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

//- (void)photoAction:(id)sender{
//    
//}

- (IBAction)changeDateAction:(id)sender {
    [self.roNumber resignFirstResponder];
    [self.comments resignFirstResponder];
    [UIView animateWithDuration:0.1f animations:^{
        [self.dateView setAlpha:1];
    }];
}

- (IBAction)confirmDateAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.roDate.text = formatedDate;
    savedDate = self.datePicker.date;
    [UIView animateWithDuration:0.1f animations:^{
        [self.dateView setAlpha:0];
    }];
}

- (IBAction)pickerAction:(id)sender {
}

- (IBAction)addPicAction:(id)sender {
}

- (IBAction)addJobsAction:(id)sender {
    [self performSegueWithIdentifier:@"jobs" sender:self];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"jobs"]) {
         [segue.destinationViewController setJobArray:_arrayOfJobs];
     }
 }

@end
