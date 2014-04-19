//
//  FYPSignUpPageViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/18/14.
//
//

#import "FYPSignUpPageViewController.h"

@interface FYPSignUpPageViewController ()
{
    BOOL viewIsResized;
}

@end

@implementation FYPSignUpPageViewController
@synthesize usernameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize confirmTextField;
@synthesize phoneTextField;
@synthesize signupButton;

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
    signupButton.layer.cornerRadius = 10;
    signupButton.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
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
        frame.origin.y -= (keyboardFrame.size.height - 190);
        
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
        frame.origin.y += (keyboardFrame.size.height - 190);
        
        [self.view setFrame:frame];
        [UIView commitAnimations];
        viewIsResized = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([usernameTextField isFirstResponder] && [touch view] != usernameTextField)
        [usernameTextField resignFirstResponder];
    if ([emailTextField isFirstResponder] && [touch view] != emailTextField)
        [emailTextField resignFirstResponder];
    if ([passwordTextField isFirstResponder] && [touch view] != passwordTextField)
        [passwordTextField resignFirstResponder];
    if ([confirmTextField isFirstResponder] && [touch view] != confirmTextField)
        [confirmTextField resignFirstResponder];
    if ([phoneTextField isFirstResponder] && [touch view] != phoneTextField)
        [phoneTextField resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
