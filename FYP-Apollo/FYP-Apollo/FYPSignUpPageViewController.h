//
//  FYPSignUpPageViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/18/14.
//
//

#import <UIKit/UIKit.h>

@interface FYPSignUpPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end
