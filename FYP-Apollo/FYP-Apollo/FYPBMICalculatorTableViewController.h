//
//  FYPBMICalculatorTableViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/26/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FYPBMICalculatorTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UILabel *bmiReadingLabel;

@end
