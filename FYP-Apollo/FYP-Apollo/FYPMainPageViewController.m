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
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [_tableView setBlurTintColor:[UIColor colorWithWhite:0.11 alpha:0.5]];
    
    [_tableView setAnimateTintAlpha:YES];
    [_tableView setStartTintAlpha:0.35f];
    [_tableView setEndTintAlpha:0.75f];
    [_tableView setFramesCount:50];
    
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
    switch(indexPath.row)
    {
        case 0:
            return 60.0;
            break;
    
        default:
            return 80.0;
            break;
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // Most if not all of this is poorly formatted styling for the table.
    //
    
    NSString *identifier;
    ANTableViewCell * cell;
    
    switch(indexPath.row)
    {
        case 0:
            identifier = @"ANTableViewTitleCell";
            break;
            
        case 1:
            identifier = @"ANTableViewBodyCell";
            break;
        
        default:
            identifier = @"ANTableViewNotificationCell";
            break;
    }
    
    cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    switch(indexPath.row)
    {
        case 0:
        {
            [cell.label setText:@"Your current BMI"];
            
            if (!cell.bottomBorder)
            {
                cell.bottomBorder = [cell createBottomBorderWithHeight:1.0f
                                                                 color:[UIColor colorWithWhite:1.0f alpha:0.75f]
                                                            leftOffset:20
                                                           rightOffset:0
                                                       andBottomOffset:0];
                [cell.layer addSublayer:cell.bottomBorder];
            }
            break;
        }
        
        case 1:
        {
            [cell.label setText:[[NSString alloc] initWithFormat: @"Height : %.2f cm\nWeight : %.2f kg\nBMI Reading : %.2f", 123.0, 456.0, 789.0]];
            break;
        }
            
        default:
        {
            if (!cell.bottomBorder)
            {
                cell.bottomBorder = [cell createBottomBorderWithHeight:0.7f
                                                                 color:[UIColor colorWithWhite:0.5f alpha:0.2f]
                                                            leftOffset:20
                                                           rightOffset:20
                                                       andBottomOffset:0];
                [cell.layer addSublayer:cell.bottomBorder];
            }
            
            /*UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(60, cell.bounds.size.height, self.view.bounds.size.width-80, 1)];
            bottomLineView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.75f];
            [cell.contentView addSubview:bottomLineView];*/
            
            UIFont *largefont = [cell.label.font fontWithSize:16.0];
            UIFont *nameFont = [self boldFontFromFont:largefont];
            NSDictionary *nameDict = [NSDictionary dictionaryWithObject: nameFont forKey:NSFontAttributeName];
            NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:@"Grumpy " attributes: nameDict];
            
            UIFont *activityFont = cell.label.font;
            NSDictionary *activityDict = [NSDictionary dictionaryWithObject:activityFont forKey:NSFontAttributeName];
            NSMutableAttributedString *activityString = [[NSMutableAttributedString alloc]initWithString: @"commented on your post" attributes:activityDict];
            
            [nameString appendAttributedString:activityString];
            cell.label.attributedText = nameString;
            
            
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
            imv.image=[UIImage imageNamed:@"cat.jpg"];
            imv.layer.cornerRadius = imv.frame.size.height/2;
            imv.layer.masksToBounds = YES;
            imv.layer.borderWidth = 2;
            imv.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.35f].CGColor;
            [cell.contentView addSubview:imv];
            
            /*[cell.imageView setFrame:CGRectMake(20, 15, 50, 50)];
            [cell.imageView setImage:[UIImage imageNamed:@"trail-running.jpg"]];
            [cell.imageView.layer setCornerRadius:cell.imageView.frame.size.height/2];
            [cell.imageView.layer setMasksToBounds:YES];
            [cell.imageView.layer setBorderWidth:2];
            [cell.imageView.layer setBorderColor:[UIColor colorWithWhite:1.0f alpha:0.75f].CGColor];*/
            
            break;
        }
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIFont *)boldFontFromFont:(UIFont *)font
{
    NSString *familyName = [font familyName];
    NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    for (NSString *fontName in fontNames)
    {
        if ([fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            UIFont *boldFont = [UIFont fontWithName:fontName size:font.pointSize];
            return boldFont;
        }
    }
    return nil;
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
