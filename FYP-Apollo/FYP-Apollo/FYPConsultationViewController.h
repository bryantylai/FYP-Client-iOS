//
//  FYPConsultationViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/4/14.
//
//

#import <UIKit/UIKit.h>

@interface FYPConsultationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
