//
//  FYPRunningMapViewController.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/17/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "MBProgressHUD.h"

@interface FYPRunningMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *runBarButton;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathView *crumbView;

@property NSDictionary *_updatedAvatar;

@end
