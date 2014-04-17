//
//  FYPMainPageViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FYPMainPageViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (retain, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;

@end
