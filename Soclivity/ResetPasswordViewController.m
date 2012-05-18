//
//  ResetPasswordViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SoclivityUtilities.h"
#import "MainServiceManager.h"
#import "ResetPasswordInvocation.h"
#define kNewPasswordNot 0
@interface ResetPasswordViewController(private)<ResetPasswordInvocationDelegate>

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    newPassword.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    confirmPassword.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];

    devServer=[[MainServiceManager alloc]init];
    [newPassword becomeFirstResponder];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"S02_cross_emb.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,19,18);
	[button addTarget:self action:@selector(CrossClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [barButtonItem release];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"S02_tick_emb.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,19,18);
	[button addTarget:self action:@selector(TickClicked:) forControlEvents:UIControlEventTouchUpInside];
	barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
	self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];

    UIImageView*passwordReset=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S01.2_passwordreset.png"]];
    self.navigationItem.titleView=passwordReset;
    [passwordReset release];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)CrossClicked:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)TickClicked:(id)sender{
    
    // Check to see if the password is even valid
    if(![SoclivityUtilities validPassword:newPassword.text]){
        
        // If the password is invalid, please clear both fields
        newPassword.text = @"";
        confirmPassword.text = @"";
        
        // Setup an alert for the invalid password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Security Alert!"
                                                        message:@"Your password should have at least 6 characters."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNewPasswordNot;
        [alert show];
        [alert release];
        return;

    }
    // Check to see the passwords match
    else if(![confirmPassword.text isEqualToString:newPassword.text]){
        
        // if the passwords don't match, first clear the fields
        newPassword.text = @"";
        confirmPassword.text = @"";
        
        // Setup an alert for passwords that don't match
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords do not match"
                                                                message:@"Please try again!"
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNewPasswordNot;
        [alert show];
        [alert release];
        return;
    }

    
    else{
       
    [devServer postResetAndConfirmNewPasswordInvocation:newPassword.text cPassword:confirmPassword.text  delegate:self];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}

-(void)ResetPasswordInvocationDidFinish:(ResetPasswordInvocation*)invocation
                           withResponse:(NSArray*)responses
                              withError:(NSError*)error{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField ==newPassword) {
        [confirmPassword becomeFirstResponder];
		
    } 
	else if(textField==confirmPassword){
		[self TickClicked:nil];
		
	}
	
	
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView resignFirstResponder];
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kNewPasswordNot:
                [newPassword becomeFirstResponder];
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
}


@end
