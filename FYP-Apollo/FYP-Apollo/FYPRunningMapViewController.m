//
//  FYPRunningMapViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/17/14.
//
//

#import "FYPRunningMapViewController.h"

@interface FYPRunningMapViewController ()
{
    BOOL track;
    BOOL init;
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
    
    self.map.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [self.locationManager startUpdatingLocation];
    
    [self.runBarButton setTarget:self];
    [self.runBarButton setAction:@selector(runButtonPressed:)];
    
    track = NO;
    init = YES;
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
        [self.runBarButton setTitle:@"Start"];
    }
    else
    {
        track = YES;
        [self.runBarButton setTitle:@"Stop"];
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
