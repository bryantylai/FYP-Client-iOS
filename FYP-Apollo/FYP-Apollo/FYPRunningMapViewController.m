//
//  FYPRunningMapViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/17/14.
//
//

#import "FYPRunningMapViewController.h"
#import "FYPConstants.h"

@interface FYPRunningMapViewController ()
{
    BOOL track;
    BOOL init;
    MBProgressHUD *_hud;
    NSString *_isError;
    NSString *_message;
    long long _startTime;
    long long _endTime;
    NSMutableArray *_path;
    double _distance;
    double _totalTime;
    double _averageSpeed;
}

@end

@implementation FYPRunningMapViewController

@synthesize map;
@synthesize runBarButton;
@synthesize locationManager;
@synthesize crumbs;
@synthesize crumbView;

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
    
    [self.navigationItem.leftBarButtonItem setTitle:@""];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    self.map.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [self.locationManager startUpdatingLocation];
    
    [self.runBarButton setTarget:self];
    [self.runBarButton setAction:@selector(runButtonPressed:)];
    
    _path = [[NSMutableArray alloc] init];
    
    track = NO;
    init = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationItem.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)switchToBackgroundMode:(BOOL)background
{
    if (background)
    {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
    }
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (newLocation)
    {
        if(init)
        {
            // On the first location update only, zoom map to user location
            MKCoordinateRegion region =
            MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
            [self.map setRegion:region animated:YES];
            [self.map setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:NO];
            
            init = NO;
        }
        
		// make sure the old and new coordinates are different
        if (track && (oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
            (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if (!self.crumbs)
            {
                // This is the first time we're getting a location update, so create
                // the CrumbPath and add it to the map.
                //
                self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
                [self.map addOverlay:self.crumbs];
                
                _distance = 0;
            }
            else
            {
                // This is a subsequent location update.
                // If the crumbs MKOverlay model object determines that the current location has moved
                // far enough from the previous location, use the returned updateRect to redraw just
                // the changed area.
                //
                // note: iPhone 3G will locate you using the triangulation of the cell towers.
                // so you may experience spikes in location data (in small time intervals)
                // due to 3G tower triangulation.
                //
                MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate];
                [_path addObject:@{@"Latitude":@(newLocation.coordinate.latitude),
                                   @"Longitude":@(newLocation.coordinate.longitude)}];
                
                if (!MKMapRectIsNull(updateRect))
                {
                    // There is a non null update rect.
                    // Compute the currently visible map zoom scale
                    MKZoomScale currentZoomScale = (CGFloat)(self.map.bounds.size.width / self.map.visibleMapRect.size.width);
                    // Find out the line width at this zoom scale and outset the updateRect by that amount
                    CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                    updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                    // Ask the overlay view to update just the changed area.
                    [self.crumbView setNeedsDisplayInMapRect:updateRect];
                }
                
                _distance += [newLocation distanceFromLocation:oldLocation];
            }
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!self.crumbView)
    {
        self.crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    
    return self.crumbView;
}

-(void)runButtonPressed:(id)sender
{
    if(track)
    {
        track = NO;
        long long tickFactor = 10000000;
        long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
        _endTime = (timeSince1970 * tickFactor ) + 621355968000000000;
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        NSDictionary* parameters = @{@"StartTime":@(_startTime),
                                     @"EndTime":@(_endTime),
                                     @"Distance":@(_distance)};
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
        
        [manager POST:@"api/avatar/run" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
         {
             _isError = [responseObject valueForKeyPath:@"IsError"];
             _message = [responseObject valueForKeyPath:@"Message"];
             _totalTime = [[responseObject valueForKeyPath:@"Duration"] doubleValue] / 10000000;
             self._updatedAvatar = [[NSDictionary alloc] initWithDictionary:[responseObject valueForKeyPath:@"Avatar"]];
             
             if([_isError intValue] == 1)
             {
                 [_hud hide:YES];
                 [self.navigationItem.leftBarButtonItem setEnabled:YES];
                 [self.navigationItem.rightBarButtonItem setEnabled:YES];
                 
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error updating user's details!"
                                                                     message:_message
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else
             {
                 _averageSpeed = _distance / _totalTime;
             
                 [_hud hide:YES];
                 [self.navigationItem.leftBarButtonItem setEnabled:YES];
                 [self.navigationItem.rightBarButtonItem setEnabled:YES];
                 
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Running Results"
                                                                     message:[NSString stringWithFormat:@"Distance : %f\n Duration : %f\n Average Speed : %f",_distance, _totalTime, _averageSpeed]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             
             [self performSegueWithIdentifier:@"completeRunning" sender:self];
         }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             [_hud hide:YES];
             [self.navigationItem.leftBarButtonItem setEnabled:YES];
             [self.navigationItem.rightBarButtonItem setEnabled:YES];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error updating user's details!"
                                                                 message:[error localizedDescription]
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];
             
         }];
        
        
    }
    else
    {
        track = YES;
        [self.runBarButton setTitle:@"End"];
        
        long long tickFactor = 10000000;
        long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
        _startTime = (timeSince1970 * tickFactor ) + 621355968000000000;
        
        self.navigationItem.hidesBackButton = YES;
    }
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
