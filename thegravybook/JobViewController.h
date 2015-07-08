//
//  JobViewController.h
//  thegravybook
//
//  Created by Andrew Boryk on 7/3/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewViewController.h"

@interface JobViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *jobArray;
@property (nonatomic, strong) NSUserDefaults *defaults;

//Properties
@property (strong, nonatomic) IBOutlet UITextField *jobTitle;
@property (strong, nonatomic) IBOutlet UITextField *accHours;
@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UITableView *jobsTable;
@property (strong, nonatomic) IBOutlet UITableView *presetTable;


@end
