//
//  FYPAppDelegate.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@interface FYPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *userAuthentication;

@property (strong, nonatomic) NSMutableDictionary *userDetails;

@property (strong, nonatomic) NSMutableDictionary *avatarDetails;

@property (strong, nonatomic) NSString *userID;

- (void) updateUsersDetails :(BOOL)firstTime;

- (void) loginToMainpage: (NSDictionary *)authentication :(BOOL)firstTime;

- (UIImage *)imageWithAlpha: (UIImage *)image :(CGFloat) alpha;

@end
