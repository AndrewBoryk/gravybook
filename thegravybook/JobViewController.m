//
//  JobViewController.m
//  thegravybook
//
//  Created by Andrew Boryk on 7/3/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "JobViewController.h"

@interface JobViewController ()

@end

BOOL adding;
UIBarButtonItem *doneButton;
UIBarButtonItem *addButton;
UIBarButtonItem *cancelButton;
UIBarButtonItem *saveButton;
@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.navigationItem setHidesBackButton:YES];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setLeftBarButtonItem:doneButton];
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    [self.addView setAlpha:0];
    adding = false;
}

- (void)doneAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction:(id)sender{
    [UIView animateWithDuration:0.1f animations:^{
        [self.addView setAlpha:0];
    }];
    self.accHours.text = nil;
    self.jobTitle.text = nil;
    adding = false;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setLeftBarButtonItem:doneButton];
    [self.navigationItem setRightBarButtonItem:addButton];
}

- (void)saveAction:(id)sender{
    if (![self.jobTitle.text isEqualToString:@""] && ![self.accHours.text isEqualToString:@""]) {
        CGFloat hourTemp = (CGFloat)[self.accHours.text floatValue];
        if (hourTemp > 0) {
            NSDictionary *job = [[NSDictionary alloc] initWithObjectsAndKeys:self.jobTitle.text, @"Name",[NSNumber numberWithFloat:hourTemp], @"Hours", nil];
            [self.jobArray addObject:job];
            [UIView animateWithDuration:0.1f animations:^{
                [self.addView setAlpha:0];
            } completion:^(BOOL finished) {
                UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Would you like to save that job to your presets?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes",nil];
                [popup showInView:self.view];
            }];
            adding = false;
            [self.jobsTable reloadData];
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            [self.navigationItem setLeftBarButtonItem:doneButton];
            [self.navigationItem setRightBarButtonItem:addButton];
            [self.jobTitle resignFirstResponder];
            [self.accHours resignFirstResponder];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter hours greater than 0." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)addAction:(id)sender{
    [UIView animateWithDuration:0.1f animations:^{
        [self.addView setAlpha:1];
    }];
    self.accHours.text = nil;
    self.jobTitle.text = nil;
    adding = true;
    [self.presetTable reloadData];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [self.navigationItem setRightBarButtonItem:saveButton];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        CGFloat hourTemp = (CGFloat)[self.accHours.text floatValue];
        NSMutableArray *temp = [[self.defaults objectForKey:@"presets"] mutableCopy];
        NSDictionary *job = [[NSDictionary alloc] initWithObjectsAndKeys:self.jobTitle.text, @"Name", [NSNumber numberWithFloat:hourTemp], @"Hours", nil];
        [temp addObject:job];
        [self.defaults setObject:temp forKey:@"presets"];
        [self.defaults synchronize];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (adding) {
        return [[_defaults objectForKey:@"presets"] count];
    }
    else {
        return [_jobArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (adding) {
        UITableViewCell *cell = [self.presetTable dequeueReusableCellWithIdentifier:@"Pre" forIndexPath:indexPath];
        NSDictionary *jobDict = [[_defaults objectForKey:@"presets"] objectAtIndex:indexPath.row];
        cell.textLabel.text = [jobDict objectForKey:@"Name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Hours: %f", [[jobDict objectForKey:@"Hours"] floatValue]];
        return cell;
    }
    else{
        UITableViewCell *cell = [self.jobsTable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *jobDict = [_jobArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [jobDict objectForKey:@"Name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Hours: %f", [[jobDict objectForKey:@"Hours"] floatValue]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (adding) {
        NSDictionary *job = [[self.defaults objectForKey:@"presets"] objectAtIndex:indexPath.row];
        [self.jobArray addObject:job];
        [UIView animateWithDuration:0.1f animations:^{
            [self.addView setAlpha:0];
        }];
        adding = false;
        [self.jobsTable reloadData];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        [self.navigationItem setLeftBarButtonItem:doneButton];
        [self.navigationItem setRightBarButtonItem:addButton];
        [self.jobTitle resignFirstResponder];
        [self.accHours resignFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setArrayOfJobs:self.jobArray];
}

@end
