//
//  FYPProfileViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/6/14.
//
//

#import "FYPProfileViewController.h"
#import "AMWaveTransition.h"

@interface FYPProfileViewController ()

@end

@implementation FYPProfileViewController
@synthesize coverpicImageView;
@synthesize profilepicImageView;
@synthesize nameLabel;
@synthesize introLabel;
@synthesize tableView;

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.separatorColor = [UIColor clearColor];
    [self.nameLabel setText:[AppDelegate.userAuthentication[@"username"] uppercaseString]];
    [self.introLabel setText:@"Introduction.........."];
    
    self.profilepicImageView.image=[UIImage imageNamed: @"dummy-profilepic.jpg"];
    self.profilepicImageView.layer.cornerRadius = self.profilepicImageView.frame.size.height/2;
    self.profilepicImageView.layer.masksToBounds = YES;
    self.profilepicImageView.layer.borderWidth = 2;
    self.profilepicImageView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.35f].CGColor;
    
    UIGraphicsBeginImageContext(self.coverpicImageView.frame.size);
    [[UIImage imageNamed:@"dummy-coverpic.jpg"] drawInRect:self.coverpicImageView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.coverpicImageView.image = image;
    
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20],
								  NSForegroundColorAttributeName: [UIColor whiteColor]};
	[self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [coverpicImageView setImageWithURL:[[AppDelegate userDetails] valueForKey:@"CoverImage"]];
    [profilepicImageView setImageWithURL:[[AppDelegate userDetails] valueForKey:@"ProfileImage"]];
    [nameLabel setText:[[AppDelegate userDetails] valueForKey:@"FirstName"]];
    [introLabel setText:[[AppDelegate userDetails] valueForKey:@"AboutMe"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch(indexPath.row)
    {
        case 0:
        {
            [cell.textLabel setText:@"Account Settings"];
            break;
        }
        case 1:
        {
            [cell.textLabel setText:@"Badges"];
            break;
        }
        case 2:
        {
            [cell.textLabel setText:@"Update BMI"];
            break;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableInsideView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableInsideView deselectRowAtIndexPath:indexPath animated:NO];

    switch (indexPath.row)
    {
        case 0:
        {
            [self performSegueWithIdentifier:@"pushToSettings" sender:indexPath];
            break;
        }
        case 1:
        {
            [self performSegueWithIdentifier:@"pushToBadges" sender:indexPath];
            break;
        }
        case 2:
        {
            [self performSegueWithIdentifier:@"pushToBMI" sender:indexPath];
            break;
        }
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editProfileUnwind:(UIStoryboardSegue *)segue
{
    if([segue.identifier isEqualToString:@"confirmEditing"])
    {
        
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
