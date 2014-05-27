//
//  FYPBMICalculatorTableViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/26/14.
//
//

#import "FYPBMICalculatorTableViewController.h"
#import "FYPConstants.h"

@interface FYPBMICalculatorTableViewController ()
{
    MBProgressHUD *_hud;
    NSString *_isError;
    NSString *_message;
    NSString *_weight;
    NSString *_height;
}

@end

@implementation FYPBMICalculatorTableViewController

@synthesize backButton;
@synthesize weightTextField;
@synthesize heightTextField;
@synthesize updateButton;
@synthesize bmiReadingLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    [updateButton addTarget:self action:@selector(updateButtonPressed:) forControlEvents:UIControlEventTouchDown];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if([[[AppDelegate userDetails] valueForKey:@"Weight"] doubleValue] != 0.0 && [[[AppDelegate userDetails] valueForKey:@"Height"] doubleValue] != 0.0)
    {
        double weight =[[[AppDelegate userDetails] valueForKey:@"Weight"] doubleValue];
        double height =[[[AppDelegate userDetails] valueForKey:@"Height"] doubleValue];
    
        [weightTextField setText:[NSString stringWithFormat:@"%.1f", weight]];
        [heightTextField setText:[NSString stringWithFormat:@"%.1f", height]];
        
        [self updateBMI];
    }
}

- (void)updateBMI
{
    double weight =[[[AppDelegate userDetails] valueForKey:@"Weight"] doubleValue];
    double height =[[[AppDelegate userDetails] valueForKey:@"Height"] doubleValue];
    
    
    double bmi = weight / (height * height);
    
    [self.bmiReadingLabel setText:[NSString stringWithFormat:@"%.1f", bmi]];
    
    if(bmi < 18.5)
        for(int i=5; i<=10; i++)
        {
            if(i==5)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor yellowColor]];
            else
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor clearColor]];
        }
    else if(bmi <= 24.9)
        for(int i=5; i<=10; i++)
        {
            if(i==6)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor yellowColor]];
            else
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor clearColor]];
        }
    else if(bmi <= 29.9)
        for(int i=5; i<=10; i++)
        {
            if(i==7)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor yellowColor]];
            else
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor clearColor]];
        }
    else if(bmi <= 34.9)
        for(int i=5; i<=10; i++)
        {
            if(i==8)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor yellowColor]];
            else
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor clearColor]];
        }
    else if(bmi <= 39.9)
        for(int i=5; i<=10; i++)
        {
            if(i==9)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor yellowColor]];
            else
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor clearColor]];
        }
    else
        for(int i=5; i<=10; i++)
        {
            if(i==10)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor yellowColor]];
            else
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setBackgroundColor:[UIColor clearColor]];
        }
    
    [self.tableView reloadData];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.tableView.superview endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateButtonPressed: (UIButton *)sender
{
    if(weightTextField.text.length==0 || heightTextField.text.length==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Proceed."
                                                            message:@"Please fill up the required fields."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        NSDictionary* parameters =
        @{@"Weight": self.weightTextField.text,
          @"Height": self.heightTextField.text};
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
        
        [manager POST:@"api/user/ios/bmi" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
         {
             _isError = [responseObject valueForKeyPath:@"IsError"];
             _message = [responseObject valueForKeyPath:@"Message"];
             _weight = [responseObject valueForKeyPath:@"Weight"];
             _height = [responseObject valueForKeyPath:@"Height"];
             
             if([_isError intValue] == 1)
             {
                 [_hud hide:YES];
                 [self.navigationItem.leftBarButtonItem setEnabled:YES];
                 [self.navigationItem.rightBarButtonItem setEnabled:YES];

                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error updating user's details!"
                                                                     message:_message
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else
             {
                 [_hud setLabelText:@"Update Complete"];
                 [_hud hide:YES afterDelay:1.5f];
                 [self.navigationItem.leftBarButtonItem setEnabled:YES];
                 [self.navigationItem.rightBarButtonItem setEnabled:YES];

                 [AppDelegate.userDetails setValue:_weight forKey:@"Weight"];
                 [AppDelegate.userDetails setValue:_height forKey:@"Height"];
                 
                 [self updateBMI];
             }
         }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             [_hud hide:YES];
             [self.navigationItem.leftBarButtonItem setEnabled:YES];
             [self.navigationItem.rightBarButtonItem setEnabled:YES];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error updating user's details!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];
         }];
    }
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
