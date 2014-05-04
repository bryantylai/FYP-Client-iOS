//
//  FYPDoctorTableViewCell.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/4/14.
//
//

#import <UIKit/UIKit.h>

@interface FYPDoctorTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong) CALayer *topBorder;
@property (strong) CALayer *bottomBorder;

@end
