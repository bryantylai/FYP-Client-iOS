//
//  FYPLoginPageViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/18/14.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@interface FYPLoginPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UILabel *loginWarningLabel;

- (IBAction)signUpUnwind:(UIStoryboardSegue *)segue;

@end
