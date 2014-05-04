//
//  FYPLoginPageViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/18/14.
//
//

#import "FYPLoginPageViewController.h"
#import "FYPSignUpPageViewController.h"

static NSString * const BaseURLString = @"https://apollo-ws.azurewebsites.net/";

@interface FYPLoginPageViewController ()
{
    BOOL viewIsResized;
    NSNumber *isError;
}

@end

@implementation FYPLoginPageViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize signupButton;
@synthesize loginWarningLabel;

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
    // Do any additional setup after loading the view.
    
    loginButton.layer.cornerRadius = 10;
    loginButton.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [loginWarningLabel setHidden:TRUE];
    
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if (!viewIsResized)
    {
        CGRect frame = self.view.frame;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        frame.origin.y -= (keyboardFrame.size.height - 100);
        
        [self.view setFrame:frame];
        viewIsResized = YES;
    }
 
    [UIView commitAnimations];
}

-(void) keyboardDidHide: (NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if (viewIsResized)
    {
        CGRect frame = self.view.frame;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        frame.origin.y = 0;
        
        [self.view setFrame:frame];
        [UIView commitAnimations];
        viewIsResized = NO;
    }
}

- (void) loginButtonPressed: (UIButton *)sender
{
    [self.loginWarningLabel setHidden:TRUE];
    
    if(self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0)
    {
        [self.loginWarningLabel setHidden:FALSE];
        return;
    }

    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDictionary *parameters = @{@"Username": usernameTextField.text, @"Email": usernameTextField.text, @"Password": passwordTextField.text};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"api/auth/login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
        {
            isError = [responseObject valueForKeyPath:@"IsError"];
            
            if([isError intValue] == 1)
            {
                [self.loginWarningLabel setHidden:FALSE];
            }
            else
            {
                /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Success!"
                                                                    message:@"Successfully logged-in"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];*/
                
                //Redirect to mainpage storyboard here
                
                /*UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
                UIViewController* initialView = [storyboard instantiateInitialViewController];
                
                [self presentViewController:initialView animated:YES completion:nil];*/
                
                [AppDelegate loginToMainpage];
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error retriving user's details"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([usernameTextField isFirstResponder] && [touch view] != usernameTextField)
        [usernameTextField resignFirstResponder];
    if ([passwordTextField isFirstResponder] && [touch view] != passwordTextField)
        [passwordTextField resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpUnwind:(UIStoryboardSegue *)segue
{
    FYPSignUpPageViewController *source = [segue sourceViewController];
    
    [usernameTextField setText:source.usernameTextField.text];
    [passwordTextField setText:@""];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignUp"])
    {
        if ([usernameTextField isFirstResponder])
            [usernameTextField resignFirstResponder];
        if ([passwordTextField isFirstResponder])
            [passwordTextField resignFirstResponder];
    }
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

@end
