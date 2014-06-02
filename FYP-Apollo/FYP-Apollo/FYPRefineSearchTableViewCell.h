//
//  FYPRefineSearchTableViewCell.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/29/14.
//
//

#import <UIKit/UIKit.h>

@interface FYPRefineSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *trainerCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *doctorCheckBox;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;

@end
