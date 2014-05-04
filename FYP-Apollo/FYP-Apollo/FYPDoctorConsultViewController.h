//
//  FYPDoctorConsultViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/4/14.
//
//

#import <UIKit/UIKit.h>
#import "SegmentedButton.h"

@interface FYPDoctorConsultViewController : UIViewController <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet SegmentedButton *buttonView;
@property (strong, nonatomic) NSDictionary* dict;

@end
