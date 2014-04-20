//
//  FYPSignUpPageViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/18/14.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@interface FYPSignUpPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameWarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailWarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordWarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmWarningLabel;

@end
