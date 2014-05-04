//
//  FYPDoctorConsultViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/4/14.
//
//

#import "FYPDoctorConsultViewController.h"
#import "AMWaveTransition.h"

@interface FYPDoctorConsultViewController ()


@end

@implementation FYPDoctorConsultViewController
@synthesize imageView;
@synthesize nameLabel;
@synthesize expertiseLabel;
@synthesize locationLabel;
@synthesize buttonView;
@synthesize dict;

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
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.nameLabel setText: dict[@"Name"]];
    [self.expertiseLabel setText: dict[@"Expertise"]];
    [self.locationLabel setText: dict[@"Location"]];
    
    self.imageView.image=[UIImage imageNamed: dict[@"Picture"]];
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.35f].CGColor;
    
    [buttonView initWithTitles:[NSArray arrayWithObjects:@"Make Appointment", @"Leave Message", nil] buttonTintNormal:[UIColor colorWithRed:0. green:0. blue:1.0 alpha:0.8] buttonTintPressed:[UIColor colorWithRed:0. green:0. blue:1.0 alpha:0.6] actionHandler:^(int buttonIndex) {
        NSLog(@"Button pressed at index %i", buttonIndex);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
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
