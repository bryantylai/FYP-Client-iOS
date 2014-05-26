//
//  FYPProfileViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/6/14.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface FYPProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverpicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilepicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)editProfileUnwind:(UIStoryboardSegue *)segue;

@end
