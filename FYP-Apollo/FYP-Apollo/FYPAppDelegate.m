//
//  FYPAppDelegate.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import "FYPAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation FYPAppDelegate


- (UIImage *)imageWithAlpha: (UIImage *)image :(CGFloat) alpha
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);

    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, image.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithAlpha:[UIImage imageNamed:@"tabbar.png"] :0.9]];
    [[UITabBar appearance] setSelectionIndicatorImage:[self imageWithAlpha:[UIImage imageNamed:@"tabbar_selected.png"] :0.5]];
    
    return YES;
}

- (void)loginToMainpage
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    UIStoryboard* mainpageStoryboard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
    UIViewController* mainpageView = [mainpageStoryboard instantiateInitialViewController];
    mainpageView.tabBarItem.title = @"Home";
    mainpageView.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"home.png"]];
    
    UIStoryboard* testStoryboard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
    UIViewController* testView = [testStoryboard instantiateInitialViewController];
    testView.tabBarItem.title = @"Test";
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:
    mainpageView,
    testView,
    nil];
    
    self.window.rootViewController = tabBarController;
    [tabBarController setSelectedIndex:1];
    [tabBarController setSelectedIndex:0];
}

- (UIImage *)imageWithImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0,0,30,30);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
