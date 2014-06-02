//
//  FYPConsultationViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/4/14.
//
//

#import "FYPConsultationViewController.h"
#import "FYPDoctorTableViewCell.h"
#import "AMWaveTransition.h"
#import "UIView+Borders.h"
#import "UIImage+BoxBlur.h"
#import "FYPDoctorConsultViewController.h"
#import "FYPRefineSearchTableViewCell.h"
#import "FYPSearchBarTableViewCell.h"

@interface FYPConsultationViewController ()
{
    BOOL searchBar;
    FYPRefineSearchTableViewCell *refineSearchCell;
    FYPSearchBarTableViewCell *searchBarCell;
    BOOL trainerSelected;
    BOOL doctorSelected;
    
    NSArray *doctorArray;
    NSArray *trainerArray;
}

@property (strong, nonatomic) NSArray *data;

@end

@implementation FYPConsultationViewController
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
    self.tableView.separatorColor = [UIColor clearColor];
    
    UIImage *processImage = [[UIImage imageNamed:@"healthcare.jpg"] drn_boxblurImageWithBlur:((CGFloat)0.2) withTintColor:[UIColor clearColor]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [processImage drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20],
								  NSForegroundColorAttributeName: [UIColor whiteColor]};
	[self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    self.data = @[
      @{@"Picture": @"doctor_house.jpg", @"Name": @"Dr. House", @"Expertise": @"Cardiology", @"Location": @"KUL, MY"},
      @{@"Picture": @"doctor_how.jpg", @"Name": @"Dr. How", @"Expertise": @"Cardiology", @"Location": @"KUL, MY"},
      @{@"Picture": @"doctor_hulk.jpg", @"Name": @"Dr. Hulk", @"Expertise": @"Cardiology", @"Location": @"KUL, MY"},
      ];
}

- (void)initRefineSearchCell
{
    trainerSelected = YES;
    doctorSelected = YES;
    [refineSearchCell.trainerCheckBox setSelected:YES];
    [refineSearchCell.doctorCheckBox setSelected:YES];

    [refineSearchCell.trainerCheckBox setBackgroundImage:[UIImage imageNamed:@"unchecked-checkbox.png"]
                                    forState:UIControlStateNormal];
    [refineSearchCell.trainerCheckBox setBackgroundImage:[UIImage imageNamed:@"checked-checkbox.png"]
                                    forState:UIControlStateSelected];
    [refineSearchCell.trainerCheckBox setBackgroundImage:[UIImage imageNamed:@"checked-checkbox.png"]
                                    forState:UIControlStateHighlighted];
    [refineSearchCell.trainerCheckBox setAdjustsImageWhenHighlighted:YES];
    [refineSearchCell.trainerCheckBox addTarget:self action:@selector(trainerChecked:) forControlEvents:UIControlEventTouchDown];
    
    
    [refineSearchCell.doctorCheckBox setBackgroundImage:[UIImage imageNamed:@"unchecked-checkbox.png"]
                                   forState:UIControlStateNormal];
    [refineSearchCell.doctorCheckBox setBackgroundImage:[UIImage imageNamed:@"checked-checkbox.png"]
                                   forState:UIControlStateSelected];
    [refineSearchCell.doctorCheckBox setBackgroundImage:[UIImage imageNamed:@"checked-checkbox.png"]
                                   forState:UIControlStateHighlighted];
    [refineSearchCell.doctorCheckBox setAdjustsImageWhenHighlighted:YES];
    [refineSearchCell.doctorCheckBox addTarget:self action:@selector(doctorChecked:) forControlEvents:UIControlEventTouchDown];
    
    [refineSearchCell.searchSegmentedControl addTarget:self action:@selector(searchSegmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)trainerChecked :(id)sender
{
    trainerSelected = !trainerSelected;
    [refineSearchCell.trainerCheckBox setSelected:trainerSelected];
}

- (void)doctorChecked :(id)sender
{
    doctorSelected = !doctorSelected;
    [refineSearchCell.doctorCheckBox setSelected:doctorSelected];
}

- (void)searchSegmentChanged :(id)sender
{

}

- (void)initSearchBarCell
{
    searchBarCell.searchBar.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count] + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
        {
            refineSearchCell = [self.tableView dequeueReusableCellWithIdentifier:@"RefineSearchCell"];
            [self initRefineSearchCell];
            [refineSearchCell setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:0.35f]];
        
            return refineSearchCell;
        }
        
        case 1:
        {
            searchBarCell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchBarCell"];
            [self initSearchBarCell];
            [searchBarCell setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:0.35f]];
            
            return searchBarCell;
        }
        
        default:
        {
            FYPDoctorTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"FYPDoctorCell"];
            
            NSDictionary* dict = self.data[indexPath.row - 2];
            
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.nameLabel setText: dict[@"Name"]];
            [cell.expertiseLabel setText: dict[@"Expertise"]];
            [cell.locationLabel setText: dict[@"Location"]];
            
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
            imv.image=[UIImage imageNamed: dict[@"Picture"]];
            imv.layer.cornerRadius = imv.frame.size.height/2;
            imv.layer.masksToBounds = YES;
            imv.layer.borderWidth = 2;
            imv.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.35f].CGColor;
            [cell.contentView addSubview:imv];
            
            if (!cell.bottomBorder)
            {
                cell.bottomBorder = [cell createBottomBorderWithHeight:0.7f
                                                                 color:[UIColor colorWithWhite:0.5f alpha:0.2f]
                                                            leftOffset:20
                                                           rightOffset:20
                                                       andBottomOffset:0];
                [cell.layer addSublayer:cell.bottomBorder];
            }
            
            return cell;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectDoctor"])
    {
        FYPDoctorConsultViewController * destination = (FYPDoctorConsultViewController *) segue.destinationViewController;
        destination.dict = self.data[[self.tableView indexPathForSelectedRow].row - 2];
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
