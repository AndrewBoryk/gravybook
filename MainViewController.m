//
//  MainViewController.m
//  thegravybook
//
//  Created by Andrew Boryk on 6/30/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

NSArray *jobsListed;
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaulted = [NSUserDefaults standardUserDefaults];
    if (![self.defaulted objectForKey:@"presets"]) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [self.defaulted setObject:temp forKey:@"presets"];
        [self.defaulted synchronize];
    }
    if (![[self.defaulted objectForKey:@"ro"]count]) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [self.defaulted setObject:temp forKey:@"ro"];
        [self.defaulted synchronize];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    jobsListed = [self.defaulted objectForKey:@"ro"];
    NSLog(@"Jobs: %@", jobsListed);
    [self.jobList reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [jobsListed count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dict = [[self.defaulted objectForKey:@"ro"] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"RO#: %@", [dict objectForKey:@"ro#"]];
    float totalHours = 0.0f;
    for (NSDictionary *tempDict in [dict objectForKey:@"jobs"]) {
        totalHours += [[tempDict objectForKey:@"Hours"] floatValue];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Accumulated Hours: %f", totalHours];
    return cell;
};

@end
