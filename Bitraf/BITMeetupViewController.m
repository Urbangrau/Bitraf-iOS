//
//  BITMeetupViewController.m
//  Bitraf
//
//  Created by Alexander Alemayhu on 19.04.14.
//  Copyright (c) 2014 Bitraf. All rights reserved.
//

#import "BITMeetupViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "BITMeetup.h"
#import "BITAppDelegate.h"
#import "FLDetailViewController.h"

@interface BITMeetupViewController ()
{
    BITAppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation BITMeetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = (BITAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (delegate.meetups.count == 0)
    {
        [_activityIndicator startAnimating];

        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:MEETUP_URL]];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            for (NSDictionary *dict in responseObject) {
                
                if ([dict isEqual:@"results"])
                {
                    for (NSDictionary *meetupDict in [responseObject valueForKey:@"results"]) {
                        BITMeetup *m = [BITMeetup withDict:meetupDict];
                        [delegate.meetups addObject:m];
                    }
                }
            }
            
            [_tableView reloadData];
            [_activityIndicator stopAnimating];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation);
        }];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BITMeetup *meetup = [delegate.meetups objectAtIndex:indexPath.row];
    
    FLDetailViewController *detailViewController = [[FLDetailViewController alloc] initWithDescription:meetup.description];
    detailViewController.title = meetup.name;
    [[self navigationController] pushViewController:detailViewController animated:YES];
}


#pragma mark - UITableViewDataSource

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return delegate.meetups.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    BITMeetup *meetup = [delegate.meetups objectAtIndex:indexPath.row];
    
    cell.textLabel.text = meetup.name;
    
    return cell;
}

@end
