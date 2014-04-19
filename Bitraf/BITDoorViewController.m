//
//  BITFirstViewController.m
//  Bitraf
//
//  Created by ccscanf on 21.03.14.
//  Copyright (c) 2014 Bitraf. All rights reserved.
//

#import "BITDoorViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface BITDoorViewController ()
{
    NSArray *errorMessages;
}

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation BITDoorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    _passwordTextField.placeholder = @"Skriv inn passord";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    
    NSString *passwd = [[NSUserDefaults standardUserDefaults] valueForKey:SavedPassword];
    if (passwd)
        _passwordTextField.text = passwd;
    
    errorMessages = [NSArray arrayWithObjects:@"Door is open.", @"Error: Too many login failures", @"Error: Only registered and paying members can use door", @"Error: You are not on the Bitraf network", @"Error: Incorrect key in URI", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Display

-(void) askToCachePassword
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setTitle:@"Passord lagring"];
    [alertView setMessage:@"Passordet ditt er ikke lagret vil du lagre det lokalt(Det lagres i klartekst)?"];
    [alertView addButtonWithTitle:@"Ja"];
    [alertView addButtonWithTitle:@"No"];
    [[self view] addSubview:alertView];
    alertView.delegate = self;
    alertView.tag = SAVEPASSWORD;
    [alertView show];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *passwd = textField.text;
    
    [self authenticateUserWithPassword:passwd];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SAVEPASSWORD)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_passwordTextField.text forKey:SavedPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - Action

- (IBAction)openDoor:(id)sender {
    [self authenticateUserWithPassword:_passwordTextField.text];
    [_passwordTextField resignFirstResponder];
}

#pragma mark - AUTH

-(void) authenticateUserWithPassword:(NSString *)passwd
{
    NSDictionary *parameters = @{DOOR_PIN    : passwd,
                                 DOOR_ACTION : @"unlock"};
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:DOOR_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Answer: %@", responseObject);
        
        if (![[NSUserDefaults standardUserDefaults] valueForKey:SavedPassword] && ![[NSUserDefaults standardUserDefaults] boolForKey:StopAskingForCachingPassword])
        {
            NSLog(@"Password not cached");
            [self askToCachePassword];
        }
        
        NSString *responseString = [NSString stringWithUTF8String:[responseObject bytes]];
        
        for (int i = 0; i < errorMessages.count; i++) {
            NSString *message = [errorMessages objectAtIndex:i];
            
            NSRange range = [responseString rangeOfString:message options:(NSCaseInsensitiveSearch)];
            
            if (range.location != NSNotFound)
            {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                [alertView setTitle:message];
                [alertView addButtonWithTitle:@"OK"];
                [[self view] addSubview:alertView];
                alertView.delegate = self;
                [alertView show];
                return ;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.debugDescription);
    }];
    
}


@end
