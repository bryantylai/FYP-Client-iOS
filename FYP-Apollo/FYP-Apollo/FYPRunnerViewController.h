//
//  FYPRunnerViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/13/14.
//
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import "BEMSimpleLineGraphView.h"

@interface FYPRunnerViewController : UIViewController <UIScrollViewDelegate, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet YLProgressBar *levelProgressBar;
//@property (weak, nonatomic) IBOutlet UILabel *nopathLabel1;
//@property (weak, nonatomic) IBOutlet UILabel *nopathLabel2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lineGraphSegmentedControl;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;

@end
