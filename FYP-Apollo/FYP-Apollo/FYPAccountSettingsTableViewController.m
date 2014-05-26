//
//  FYPAccountSettingsTableViewController.m
//  FYP-Apollo
//
//  Created by Wicky Lim on 5/20/14.
//
//

#import "FYPAccountSettingsTableViewController.h"
#import "FYPConstants.h"

@interface FYPAccountSettingsTableViewController ()
{
    UIDatePicker *_datePicker;
    NSDictionary *_dict;
    MBProgressHUD *_hud;
    NSString *_isError;
    NSString *_message;
}

@end

@implementation FYPAccountSettingsTableViewController

@synthesize doneButton;
@synthesize profilepicImageView;
@synthesize coverpicImageView;
@synthesize editProfilepicButton;
@synthesize editCoverpicButton;
@synthesize nameTextField;
@synthesize lastNameTextField;
@synthesize aboutTextView;
@synthesize genderSegmentedControl;
@synthesize dobTextField;
@synthesize phoneTextField;

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
    
    self.aboutTextView.delegate = self;
    
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    [editProfilepicButton addTarget:self action:@selector(editProfilepicButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [editCoverpicButton addTarget:self action:@selector(editCoverpicButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dobTextField.inputView = _datePicker;
    
    [doneButton setTarget:self];
    [doneButton setAction:@selector(doneButtonPressed:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if([[AppDelegate userDetails] count] == 0)
    {
        [coverpicImageView setImage:[UIImage imageNamed:@"dummy-coverpic.jpg"]];
        [profilepicImageView setImage:[UIImage imageNamed:@"dummy-profilepic.jpg"]];
    }
    else
    {
        [coverpicImageView setImageWithURL:[[AppDelegate userDetails] valueForKey:@"CoverImage"]];
        [profilepicImageView setImageWithURL:[[AppDelegate userDetails] valueForKey:@"ProfileImage"]];
        [nameTextField setText:[[AppDelegate userDetails] valueForKey:@"FirstName"]];
        [lastNameTextField setText:[[AppDelegate userDetails] valueForKey:@"LastName"]];
        [aboutTextView setText:[[AppDelegate userDetails] valueForKey:@"AboutMe"]];
        [genderSegmentedControl setSelectedSegmentIndex:[(NSString *)[[AppDelegate userDetails] valueForKey:@"Gender"] isEqualToString:@"Male"] ? 0 : 1 ];
        long long ticks = [[(NSString *)[AppDelegate userDetails] valueForKey:@"DateOfBirth"] longLongValue];
        long long ticksSince1970 = (ticks - 621355968000000000) / 10000000;
        [_datePicker setDate:[NSDate dateWithTimeIntervalSince1970:ticksSince1970]];
        [self datePickerValueChanged:_datePicker];
        [phoneTextField setText:[[AppDelegate userDetails] valueForKey:@"Phone"]];
    }
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.tableView.superview endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.aboutTextView setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([nameTextField isFirstResponder] && [touch view] != nameTextField)
        [nameTextField resignFirstResponder];
    if ([aboutTextView isFirstResponder] && [touch view] != aboutTextView)
        [aboutTextView resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

- (void) doneButtonPressed: (UIBarButtonItem *)sender
{
    if(nameTextField.text.length!=0 && lastNameTextField.text.length!=0 && aboutTextView.text.length!=0 && dobTextField.text.length!=0)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        
        S3PutObjectRequest *porPro = [[S3PutObjectRequest alloc] initWithKey:[NSString stringWithFormat: @"%@/profilepic.png", [AppDelegate userID]] inBucket:@"apollo-fyp"];
        porPro.contentType = @"image/png";
        porPro.data = [NSData dataWithData:UIImagePNGRepresentation(profilepicImageView.image)];
        porPro.cannedACL = [S3CannedACL publicRead];
        porPro.delegate = self;
        [s3 putObject:porPro];
        
        S3PutObjectRequest *porCov = [[S3PutObjectRequest alloc] initWithKey:[NSString stringWithFormat: @"%@/coverpic.png", [AppDelegate userID]] inBucket:@"apollo-fyp"];
        porCov.contentType = @"image/jpeg";
        porCov.data = [NSData dataWithData:UIImagePNGRepresentation(coverpicImageView.image)];
        porCov.cannedACL = [S3CannedACL publicRead];
        porCov.delegate = self;
        [s3 putObject:porCov];
        
        long long tickFactor = 10000000;
        long long timeSince1970 = [_datePicker.date timeIntervalSince1970];
        long long dateTicks = (timeSince1970 * tickFactor ) + 621355968000000000;
        
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        NSDictionary* parameters =
        @{@"ProfileImage":[NSString stringWithFormat:@"%@%@%@", BUCKET_URL, [AppDelegate userID], @"/profilepic.png"],
          @"CoverImage":[NSString stringWithFormat:@"%@%@%@", BUCKET_URL, [AppDelegate userID], @"/coverpic.png"],
          @"FirstName": nameTextField.text,
          @"Lastname": lastNameTextField.text,
          @"AboutMe": aboutTextView.text,
          @"Gender": genderSegmentedControl.selectedSegmentIndex == 0 ? @"Male" : @"Female",
          @"DateOfBirth":@(dateTicks),
          @"Phone":phoneTextField.text};
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:AppDelegate.userAuthentication[@"username"] password:AppDelegate.userAuthentication[@"password"]];
        
        [manager POST:@"api/user/ios/profile" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
         {
             _isError = [responseObject valueForKeyPath:@"IsError"];
             _message = [responseObject valueForKeyPath:@"Message"];
             
             if([_isError intValue] == 1)
             {
                 [_hud setLabelText:@"Editting error!"];
                 [_hud hide:YES afterDelay:1.0f];
                 [self.navigationItem.leftBarButtonItem setEnabled:YES];
                 [self.navigationItem.rightBarButtonItem setEnabled:YES];
                 NSLog(@"%@", _message);
             }
             else
             {
                 [_hud setLabelText:@"Completed."];
                 [_hud hide:YES afterDelay:1.0f];
                 
                 [AppDelegate updateUsersDetails:NO];
                 
                 [self performSegueWithIdentifier:@"confirmEditing" sender:doneButton];
                 [self.navigationItem.leftBarButtonItem setEnabled:YES];
                 [self.navigationItem.rightBarButtonItem setEnabled:YES];
             }
         }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error signing up user!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];
         }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Proceed."
                                                            message:@"Please fill up required fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) editProfilepicButtonPressed: (UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.view.tag = 10;
}

- (void) editCoverpicButtonPressed: (UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker.view setTag:11];
}

- (void)datePickerValueChanged: (UIDatePicker*)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    [self.dobTextField setText: [formatter stringFromDate:sender.date]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:NO completion:nil];
    
    if(picker.view.tag == 10)
    {
        [self.profilepicImageView setImage:image];
    }
    if(picker.view.tag == 11)
    {
        [self.coverpicImageView setImage:image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AmazonServiceRequestDelegate
-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long) bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
//    double percent = ((double)totalBytesWritten/(double)totalBytesExpectedToWrite);
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError called: %@", error);
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"didFailWithServiceException called: %@", exception);
}

#pragma mark - Table view data source

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
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
