//
//  FYPAppDelegate.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import "FYPAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "FYPConstants.h"

@implementation FYPAppDelegate

@synthesize userAuthentication;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithAlpha:[UIImage imageNamed:@"tabbar.png"] :0.9]];
    [[UITabBar appearance] setSelectionIndicatorImage:[self imageWithAlpha:[UIImage imageNamed:@"tabbar_selected.png"] :0.5]];
    
    self.userDetails = [[NSMutableDictionary alloc] init];
    self.avatarDetails = [[NSMutableDictionary alloc] init];
    
    return YES;
}

- (void)loginToMainpage: (NSDictionary *)authentication : (BOOL)firstTime
{
    self.userAuthentication = authentication;
    
    [self updateUsersDetails :firstTime];
    [self updateAvatarDetails :firstTime];
    [self updateProfessionalsList];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    UIStoryboard* mainpageStoryboard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
    UIViewController* mainpageView = [mainpageStoryboard instantiateInitialViewController];
    mainpageView.tabBarItem.title = @"Home";
    mainpageView.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"home.png"]];
    
    UIStoryboard* runnerStoryboard = [UIStoryboard storyboardWithName:@"Runner" bundle:nil];
    UIViewController* runnerView = [runnerStoryboard instantiateInitialViewController];
    runnerView.tabBarItem.title = @"Runner";
    runnerView.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"runner.png"]];
    
    UIStoryboard* consultStoryboard = [UIStoryboard storyboardWithName:@"Consultation" bundle:nil];
    UIViewController* consultView = [consultStoryboard instantiateInitialViewController];
    consultView.tabBarItem.title = @"Doctors";
    consultView.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"stethoscope.png"]];
    
    UIStoryboard* profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UIViewController* profileView = [profileStoryboard instantiateInitialViewController];
    profileView.tabBarItem.title = @"Profile";
    profileView.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"profile.png"]];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:
                                        mainpageView,
                                        runnerView,
                                        consultView,
                                        profileView,
                                        nil];
    
    self.window.rootViewController = tabBarController;
    [tabBarController setSelectedIndex:3];
    
    if(firstTime)
    {
        UINavigationController *nav = (UINavigationController*)tabBarController.selectedViewController;
        UIViewController* accountSettingsView = [profileStoryboard instantiateViewControllerWithIdentifier:@"accountSettings"];
        
        [nav pushViewController:accountSettingsView animated:YES];
    }
    else
        [tabBarController setSelectedIndex:0];
}

- (void) updateUsersDetails :(BOOL)firstTime
{
    if(firstTime)
    {
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
        
        [manager GET:@"api/user/profile" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             self.userID = [responseObject valueForKeyPath:@"Id"];
         }
             failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User's Details!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];
         }];
    }
    else
    {
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
        
        [manager GET:@"api/user/profile" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             self.userID = [responseObject valueForKeyPath:@"Id"];
             
             [self.userDetails setValue:[responseObject valueForKey:@"ProfileImage"] forKey:@"ProfileImage"];
             [self.userDetails setValue:[responseObject valueForKey:@"CoverImage"] forKey:@"CoverImage"];
             [self.userDetails setValue:[responseObject valueForKey:@"FirstName"] forKey:@"FirstName"];
             [self.userDetails setValue:[responseObject valueForKey:@"LastName"] forKey:@"LastName"];
             [self.userDetails setValue:[responseObject valueForKey:@"AboutMe"] forKey:@"AboutMe"];
             [self.userDetails setValue:[responseObject valueForKey:@"Gender"] forKey:@"Gender"];
             [self.userDetails setValue:[responseObject valueForKey:@"DateOfBirth"] forKey:@"DateOfBirth"];
             [self.userDetails setValue:[responseObject valueForKey:@"Phone"] forKey:@"Phone"];
             [self.userDetails setValue:[responseObject valueForKey:@"Weight"] forKey:@"Weight"];
             [self.userDetails setValue:[responseObject valueForKey:@"Height"] forKey:@"Height"];
         }
             failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User's Details!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];
         }];
    }
}

- (void) updateAvatarDetails :(BOOL)firstTime
{
    if(firstTime)
    {
        [self.avatarDetails setValue:@"Doge" forKey:@"Name"];
        [self.avatarDetails setValue:@"1" forKey:@"Level"];
        [self.avatarDetails setValue:@"0.0" forKey:@"Experience"];
        [self.avatarDetails setValue:[[NSArray alloc] init] forKey:@"All"];
        [self.avatarDetails setValue:[[NSArray alloc] init] forKey:@"Month"];
        [self.avatarDetails setValue:[[NSArray alloc] init] forKey:@"Week"];
        [self.avatarDetails setValue:[[NSArray alloc] init] forKey:@"Day"];
    }
    else
    {
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
        
        [manager GET:@"api/avatar/profile" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             [self.avatarDetails setValue:@"Doge" forKey:@"Name"];
             [self.avatarDetails setValue:[responseObject valueForKey:@"Level"] forKey:@"Level"];
             [self.avatarDetails setValue:[responseObject valueForKey:@"Experience"] forKey:@"Experience"];
             [self.avatarDetails setValue:[[NSArray alloc] initWithArray:[responseObject objectForKey:@"All"]] forKey:@"All"];
             [self.avatarDetails setValue:[[NSArray alloc] initWithArray:[responseObject objectForKey:@"Month"]] forKey:@"Month"];
             [self.avatarDetails setValue:[[NSArray alloc] initWithArray:[responseObject objectForKey:@"Week"]] forKey:@"Week"];
             [self.avatarDetails setValue:[[NSArray alloc] initWithArray:[responseObject objectForKey:@"Day"]] forKey:@"Day"];
         }
             failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Avatar's Details!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];
         }];
    }
}

- (void)updateProfessionalsList
{
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
    
    [manager GET:@"api/doctor/fetch-all" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
        self.doctorArray = [[NSArray alloc] initWithArray:responseObject];
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Doctors' List!"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}

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
