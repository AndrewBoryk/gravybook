//
//  MainViewController.h
//  thegravybook
//
//  Created by Andrew Boryk on 6/30/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//Properties
@property (strong, nonatomic) IBOutlet UITableView *jobList;
@property (strong, nonatomic) IBOutlet UILabel *totalHours;
@property (strong, nonatomic) NSUserDefaults *defaulted;
@end
