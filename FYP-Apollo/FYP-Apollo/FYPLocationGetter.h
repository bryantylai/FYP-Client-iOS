//
//  FYPLocationGetter.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationGetterDelegate <NSObject>

@required
- (void) newPhysicalLocation:(CLLocation *)location;

@end

@interface FYPLocationGetter : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    id delegate;
}

- (void)startUpdates;
 
@property(retain, nonatomic) CLLocationManager *locationManager;
@property(retain, nonatomic) id delegate;

@end
