//
//  FYPMainPageViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import <UIKit/UIKit.h>
#import "ANBlurredTableView.h"

@interface FYPMainPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (assign) IBOutlet ANBlurredTableView *tableView;

- (UIFont *)boldFontFromFont:(UIFont *)font;

@end
