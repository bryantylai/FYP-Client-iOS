//
//  FYPMainPageViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 4/17/14.
//
//

#import "FYPMainPageViewController.h"
#import "ANTableViewCell.h"
#import "UIView+Borders.h"

@interface FYPMainPageViewController ()

@end

@implementation FYPMainPageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Hide our statusbar for a prettier look.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [_tableView setBlurTintColor:[UIColor colorWithWhite:0.11 alpha:0.5]];
    
    [_tableView setAnimateTintAlpha:YES];
    [_tableView setStartTintAlpha:0.35f];
    [_tableView setEndTintAlpha:0.75f];
    [_tableView setFramesCount:100];
    
    [_tableView setBackgroundImage:[UIImage imageNamed:@"trail-running.jpg"]];
    
    [_tableView setContentInset:UIEdgeInsetsMake(0.0, 0, 0, 0)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Make sure we have enough rows to demonstrate the blur effect.
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // Most if not all of this is poorly formatted styling for the table.
    //
    
    NSString *identifier;
    ANTableViewCell * cell;
    
    if (indexPath.row == 0){
        identifier = @"ANTableViewCell";
    }
    else if (indexPath.row == 1)
    {
        identifier = @"ANTableViewCenterBodyCell";
    }
    else if (indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 11 || indexPath.row > 12)
    {
        identifier = @"ANTableViewBodyCell";
    }
    else if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 10 ||  indexPath.row == 12){
        identifier = @"ANTableViewTitleCell";
    }
    
    cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.row == 0)
    {
        // Styling
        [cell.label setText:@"ANBlurredTableView!"];
    }
    else if (indexPath.row == 1){
        // Styling
        [cell.label setText:@"ANBlurredTableView is a simple and flexible UITableView subclass for blurring and tinting the background image of a UITableView on scroll.\n\n Scroll to see it in action."];
    }
    else if (indexPath.row == 2){
        // Bottom Border
        if (!cell.bottomBorder){
            cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                             color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                        leftOffset:20
                                                       rightOffset:0
                                                   andBottomOffset:0];
            [cell.layer addSublayer:cell.bottomBorder];
        }
        
        // Styling
        [cell.label setText:@"ANIMATE TINT ALPHA"];
    }
    else if (indexPath.row == 3)
    {
        // Styling
        [cell.label setText:@"Animate between two alphas to simulate darkening or lightening while scrolling."];
    }
    else if (indexPath.row == 4)
    {
        // Bottom Border
        if (!cell.bottomBorder){
            cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                             color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                        leftOffset:20
                                                       rightOffset:0
                                                   andBottomOffset:0];
            [cell.layer addSublayer:cell.bottomBorder];
        }
        
        // Styling
        [cell.label setText:@"BACKGROUND RENDERING"];
    }
    else if (indexPath.row == 5)
    {
        [cell.label setText:@"All frames are rendered in the background. On slower devices, ANBlurredTableView will animate the blur-in to the user's current contentOffset when rendering has finished."];
    }
    else if (indexPath.row == 6)
    {
        // Bottom Border
        if (!cell.bottomBorder){
            cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                             color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                        leftOffset:20
                                                       rightOffset:0
                                                   andBottomOffset:0];
            [cell.layer addSublayer:cell.bottomBorder];
        }
        
        // Styling
        [cell.label setText:@"AND MORE!"];
        
    }
    else if (indexPath.row == 7)
    {
        // Styling
        [cell.label setText:@"Customize your blur with custom tints, scroll lengths and more!"];
    }
    
    else if (indexPath.row == 8)
    {
        // Bottom Border Setup
        if (!cell.bottomBorder){
            cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                             color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                        leftOffset:20
                                                       rightOffset:0
                                                   andBottomOffset:0];
            [cell.layer addSublayer:cell.bottomBorder];
        }
        
        // Styling
        [cell.label setText:@"CONTRIBUTE"];
        
    }
    
    else if (indexPath.row == 9)
    {
        //Styling
        [cell.label setText:@"Help make ANBlurredTableView by contributing! Find me on Github at github.com/aaronn"];
    }
    
    else if (indexPath.row == 10)
    {
        // Bottom Border
        if (!cell.bottomBorder){
            cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                             color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                        leftOffset:20
                                                       rightOffset:0
                                                   andBottomOffset:0];
            [cell.layer addSublayer:cell.bottomBorder];
        }
        
        // Styling
        [cell.label setText:@"CREDITS"];
    }
    
    else if (indexPath.row == 11)
    {
        //Styling
        [cell.label setText:@"Made by Aaron Ng. Follow me on Twitter at @aaronykng."];
    }
    
    else if (indexPath.row == 12)
    {
        // Border
        if (!cell.bottomBorder){
            cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                             color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                        leftOffset:20
                                                       rightOffset:0
                                                   andBottomOffset:0];
            [cell.layer addSublayer:cell.bottomBorder];
        }
        
        // Styling
        [cell.label setText:@"FILLER ROWS"];
        
    }
    
    else if (indexPath.row > 12){
        //Styling
        if (cell == nil){
            [cell.label setTextAlignment:NSTextAlignmentLeft];
        }
        [cell.label setText:@"A Dummy Row"];
    }
    
    return cell;
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
