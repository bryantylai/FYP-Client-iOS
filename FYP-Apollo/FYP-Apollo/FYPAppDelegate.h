//
//  FYPAppDelegate.h
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import <UIKit/UIKit.h>

@interface FYPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) loginToMainpage;

- (UIImage *)imageWithAlpha: (UIImage *)image :(CGFloat) alpha;

@end
