//
//  FYPMainPageViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import "FYPMainPageViewController.h"

@interface FYPMainPageViewController ()

@end

@implementation FYPMainPageViewController
@synthesize locationManager;
@synthesize labelOne;
@synthesize labelTwo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone]; 
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [labelOne setText:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude]];
 
    [labelTwo setText:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
