//
//  FYPAccountSettingsTableViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/20/14.
//
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>
#import "MBProgressHUD.h"
#import "FYPAboutTextView.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"

@interface FYPAccountSettingsTableViewController : UITableViewController <UITextViewDelegate, UINavigationControllerDelegate ,UIImagePickerControllerDelegate, AmazonServiceRequestDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilepicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverpicImageView;
@property (weak, nonatomic) IBOutlet UIButton *editProfilepicButton;
@property (weak, nonatomic) IBOutlet UIButton *editCoverpicButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet FYPAboutTextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end
