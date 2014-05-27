//
//  FYPRunnerViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/13/14.
//
//

#import "FYPRunnerViewController.h"
#import <MapKit/MapKit.h>

@interface FYPRunnerViewController ()
{
    int intMaxLength,intStartPosition;
    CGSize svSize;
    
    NSMutableArray *ArrayOfValues;
    NSMutableArray *ArrayOfDates;
    float totalNumber;
}

@end

@implementation FYPRunnerViewController

@synthesize containerScrollView;
//@synthesize scrollView;
@synthesize nameLabel;
@synthesize levelLabel;
@synthesize levelProgressBar;
//@synthesize nopathLabel1;
//@synthesize nopathLabel2;
@synthesize lineGraphSegmentedControl;
@synthesize lineGraph;

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20],
								  NSForegroundColorAttributeName: [UIColor whiteColor]};
	[self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.containerScrollView.delegate = self;
    [self.containerScrollView setScrollEnabled:YES];
    
    
    //Set-up user's avatar information
    [self.avatarImageView setImage:[UIImage imageNamed:@"doge.jpeg"]];
    [self.nameLabel setText:@"Doge"];
    [self.levelLabel setText:@"Lvl. over 9999"];
    [self.levelProgressBar setProgressTintColor:[UIColor colorWithRed:239/255.0f green:225/255.0f blue:13/255.0f alpha:1.0f]];
    [self.levelProgressBar setIndicatorTextDisplayMode:YLProgressBarIndicatorTextDisplayModeProgress];
    [self.levelProgressBar.indicatorTextLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
    [self.levelProgressBar setStripesColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    [self.levelProgressBar setProgress:0.99f animated:YES];
    
    
    //Set-up paths banner -- To Be Removed
//    [self.nopathLabel1 setHidden:YES];
//    [self.nopathLabel2 setHidden:YES];
//    
//    self.scrollView.delegate = self;
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    [self.scrollView setShowsHorizontalScrollIndicator:NO];
//    [self.scrollView setScrollEnabled:NO];
//    svSize = self.scrollView.frame.size;
//    
//    
//    NSArray *imagesArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"dummy-profilepic.jpg"] ,
//                            [UIImage imageNamed:@"dummy-coverpic.jpg"] ,
//                            [UIImage imageNamed:@"cat.jpg"] ,
//                            [[MKMapView alloc] init] ,
//                            nil];
//    
//    intMaxLength = [imagesArray count] * svSize.width;
//    
//    
//    int xPosition = 0;
//    
//    for(int i = 0 ; i < [imagesArray count] ; i++)
//    {
//        if([[imagesArray objectAtIndex:i] isKindOfClass:[UIImage class]])
//        {
//            UIImageView *ivImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, 0, svSize.width, svSize.height)];
//            
//            ivImage.image = [imagesArray objectAtIndex:i];
//            
//            [self.scrollView addSubview:ivImage];
//        }
//        else
//        {
//            MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(xPosition, 0, svSize.width, svSize.height)];
//            
//            [self.scrollView addSubview:mapView];
//        }
//        
//        xPosition += svSize.width;
//    }
//    
//    intStartPosition = 0;
//    
//    UISwipeGestureRecognizer *recognizer;
//    
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [[self scrollView] addGestureRecognizer:recognizer];
//    
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [[self scrollView] addGestureRecognizer:recognizer];
    
    
    //Set-up distance graph
    self.lineGraph.delegate = self;
    ArrayOfValues = [[NSMutableArray alloc] init];
    ArrayOfDates = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 9; i++)
    {
        //DUMMY Data
    
        [ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 70000)]]; // Random values for the graph
        [ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    
    self.lineGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.lineGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.lineGraph.colorLine = [UIColor whiteColor];
    self.lineGraph.colorXaxisLabel = [UIColor whiteColor];
    self.lineGraph.widthLine = 3.0;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.enablePopUpReport = YES;
    self.lineGraph.enableBezierCurve = YES;
}

- (void)viewDidLayoutSubviews
{
    self.containerScrollView.contentSize = CGSizeMake(320, 665);
}

//-(IBAction)handleSwipeFrom:(UISwipeGestureRecognizer*)sender
//{
//    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
//    {
//        if(intMaxLength <= intStartPosition + svSize.width)
//        {
//            return;
//        }
//        else
//        {
//            intStartPosition += svSize.width;
//            [self.scrollView setContentOffset:CGPointMake(intStartPosition,0) animated:YES];
//        }
//
//    }
//    else if(sender.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//        if(0 > intStartPosition - svSize.width)
//        {
//            return;
//        }
//        else
//        {
//            intStartPosition -= svSize.width;
//            [self.scrollView setContentOffset:CGPointMake(intStartPosition,0) animated:YES];
//        }
//
//    }
//}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return (int)[ArrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[ArrayOfValues objectAtIndex:index] floatValue];
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    return [ArrayOfDates objectAtIndex:index];
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
