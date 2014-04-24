//
//  YookaSearchViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaSearchViewController.h"
#import "YookaViewController.h"
#import "YookaAppDelegate.h"
#import "UserFollowingViewController.h"
#import "UserFollowersViewController.h"
#import "BDViewController2.h"
#import <AsyncImageDownloader.h>
#import "YookaBackend.h"
#import <Reachability.h>

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
@interface YookaSearchViewController ()

@end

@implementation YookaSearchViewController

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

    j=0;
    k=0;
    
    UIColor * color2 = [UIColor colorWithRed:244/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f];
    [self.view setBackgroundColor:color2];

    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    _userFollowingPicture = [NSMutableArray new];
    
    _userEmail = [KCSUser activeUser].username;
    _firstName = [KCSUser activeUser].givenName;
    _lastName = [KCSUser activeUser].surname;
    _userFullName = [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
    NSLog(@"%@ %@ %@ %@",_userEmail,_firstName,_lastName,_userFullName);
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"Users"];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, 300, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _textField.textColor = [UIColor lightGrayColor];
    UIColor *color1 = [UIColor grayColor];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"                   🔍 Find a user" attributes:@{NSForegroundColorAttributeName: color1}];
    UIColor * color3 = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    _textField.backgroundColor = color3;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textField addTarget:self
                   action:@selector(textFieldDone:)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_textField];
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 110.f, 320.f, self.view.bounds.size.height-150.f)];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    [_searchTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:_searchTableView];
    
    [self.view setUserInteractionEnabled:YES];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self Load100Users];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

-(void)Load100Users
{
    KCSAppdataStore* store = [KCSAppdataStore storeWithCollection:[KCSCollection userCollection] options:nil];
    KCSQuery* query = [KCSQuery query];
    query.limitModifer = [[KCSQueryLimitModifier alloc] initWithLimit:7];
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //handle completion
        if (errorOrNil == nil) {
            //array of matching KCSUser objects
            //                                                NSLog(@"Found %lu users", (unsigned long)objectsOrNil.count);
            if (objectsOrNil && objectsOrNil.count) {
                [_userFollowingPictureUrl removeAllObjects];
                [_userFollowingFullName removeAllObjects];
                _results = [NSMutableArray new];
                _results = [NSMutableArray arrayWithArray:objectsOrNil];
                [self userSearchNames];
                
            }else{
                _userFollowingEmail = [NSMutableArray new];
                _userFollowingPicture = [NSMutableArray new];
                _userFollowingPictureUrl = [NSMutableArray new];
                _userFollowingFullName = [NSMutableArray new];
                NSString *string = @"          No users found.";
                [_userFollowingFullName insertObject:string atIndex:0];
                [self.searchTableView reloadData];
                [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                //                                                    NSLog(@"Found users none = %@", _userFollowingFullName);
            }
            
            
        } else {
            //                                                NSLog(@"Got An error: %@", errorOrNil);
        }
    } withProgressBlock:nil];
}

-(void)dismissKeyboard {
    [_textField resignFirstResponder];
}

-(IBAction)textFieldDone:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    NSString *s = [[_textField text]capitalizedString];
//    NSLog(@"search %@",s);
    
    NSArray* firstLastStrings = [s componentsSeparatedByString:@" "];
    
    [_textField resignFirstResponder];
    
    _userFollowingEmail = [NSMutableArray new];
    _userFollowingPicture = [NSMutableArray new];
    _userFollowingPictureUrl = [NSMutableArray new];
    _userFollowingFullName = [NSMutableArray new];

    
    if (firstLastStrings.count>1) {
        _firstName = [[firstLastStrings objectAtIndex:0]capitalizedString];
        _lastName = [[firstLastStrings objectAtIndex:1]capitalizedString];

        [KCSUserDiscovery lookupUsersForFieldsAndValues:@{ KCSUserAttributeGivenname : _firstName,KCSUserAttributeSurname : _lastName}
                                        completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                            if (errorOrNil == nil) {
                                                //array of matching KCSUser objects
//                                                NSLog(@"Found %lu users", (unsigned long)objectsOrNil.count);
                                                if (objectsOrNil && objectsOrNil.count) {
                                                    [_userFollowingPictureUrl removeAllObjects];
                                                    [_userFollowingFullName removeAllObjects];
                                                    _results = [NSMutableArray new];
                                                    _results = [NSMutableArray arrayWithArray:objectsOrNil];
                                                    [self userSearchNames];

                                                }else{
                                                    _userFollowingEmail = [NSMutableArray new];
                                                    _userFollowingPicture = [NSMutableArray new];
                                                    _userFollowingPictureUrl = [NSMutableArray new];
                                                    _userFollowingFullName = [NSMutableArray new];
                                                    NSString *string = @"          No users found.";
                                                    [_userFollowingFullName insertObject:string atIndex:0];
                                                    [self.searchTableView reloadData];
                                                    [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
//                                                    NSLog(@"Found users none = %@", _userFollowingFullName);
                                                }

                                                
                                            } else {
//                                                NSLog(@"Got An error: %@", errorOrNil);
                                            }
                                        }
                                          progressBlock:nil];
        
    }else{
        
        _firstName = s;
        _lastName=nil;
        
        [KCSUserDiscovery lookupUsersForFieldsAndValues:@{ KCSUserAttributeGivenname : _firstName}
                                        completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                            if (errorOrNil == nil) {
                                                //array of matching KCSUser objects
//                                                NSLog(@"Found %lu %@", (unsigned long)objectsOrNil.count,s);
                                                if (objectsOrNil && objectsOrNil.count) {
                                                    [_userFollowingPictureUrl removeAllObjects];
                                                    [_userFollowingFullName removeAllObjects];
                                                    _results = [NSMutableArray new];
                                                    _results = [NSMutableArray arrayWithArray:objectsOrNil];
                                                    [self userSearchNames];
//                                                    NSLog(@"Found users = %@", _userFollowing);

                                                }else{
                                                    

                                                    [_userFollowingEmail removeAllObjects];
                                                    [_userFollowingPictureUrl removeAllObjects];
                                                    _userFollowingPictureUrl = [NSMutableArray new];
                                                    [_userFollowingFullName removeAllObjects];
                                                    [_userFollowingPicture removeAllObjects];
                                                    NSString *string = @"          No users found.";
                                                    [_userFollowingFullName insertObject:string atIndex:0];
                                                    [self.searchTableView reloadData];
                                                    [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                                                    _userPicUrl = nil;

                                                    NSLog(@"Found users none = %@", _userFollowingFullName);

                                                }
                                            } else {
//                                                NSLog(@"Got An error: %@", errorOrNil);
                                            }
                                        }
                                          progressBlock:nil];
    }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)userSearchNames
{
    int i;
    j=0;
    _userFollowingEmail = [NSMutableArray new];
    _userFollowingPicture = [NSMutableArray new];
    _userFollowingPictureUrl = [NSMutableArray new];
    _userFollowingFullName = [NSMutableArray new];
    
    for (i=0; i<_results.count; i++) {
        
        KCSUser *user = _results[i];
        [_userFollowingEmail addObject:user.username];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",user.givenName,user.surname];
        [_userFollowingFullName addObject:fullName];
//        NSLog(@"%@ %@",_userFollowingEmail,_userFollowingFullName);
        
        if (_userFollowingFullName.count == _results.count) {
            [self getUserPictures];
            [self.searchTableView reloadData];
            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }else{
//            [self.searchTableView reloadData];
//            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }

    }
    

    
}

- (void)userSearchNames2
{
    int i;
    j=0;
    _userFollowingEmail = [NSMutableArray new];
    _userFollowingPicture = [NSMutableArray new];
    _userFollowingPictureUrl = [NSMutableArray new];
    _userFollowingFullName = [NSMutableArray new];
    [_userFollowingEmail addObjectsFromArray:@[@"jeff@getyooka.com",@"thomasmaking@gmail.com",@"joshua.cleetus@gmail.com",@"wbracket@gmail.com"]];
//    [_userFollowingEmail insertObject:@"jeff@getyooka.com" atIndex:0];
//    [_userFollowingEmail insertObject:@"thomasmaking@gmail.com" atIndex:1];
//    [_userFollowingEmail insertObject:@"joshua.cleetus@gmail.com" atIndex:2];
//    [_userFollowingEmail insertObject:@"wbracket@gmail.com" atIndex:3];
    [_userFollowingEmail addObjectsFromArray:@[@"Jeffrey Oh",@"Thomas Noh",@"Joshua Cleetus",@"Will Brackett"]];
//    [_userFollowingFullName insertObject:@"Jeffrey Oh" atIndex:0];
//    [_userFollowingFullName insertObject:@"Thomas Noh" atIndex:1];
//    [_userFollowingFullName insertObject:@"Joshua Cleetus" atIndex:2];
//    [_userFollowingFullName insertObject:@"Will Brackett" atIndex:3];
    
    for (i=0; i<_results.count; i++) {
        
        KCSUser *user = _results[i];
        [_userFollowingEmail addObject:user.username];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",user.givenName,user.surname];
        [_userFollowingFullName addObject:fullName];
        //        NSLog(@"%@ %@",_userFollowingEmail,_userFollowingFullName);
        
        if (_userFollowingFullName.count == _results.count+4) {
//            [_userFollowingEmail insertObjects:@[@"jeff@getyooka.com",@"thomasmaking@gmail.com",@"joshua.cleetus@gmail.com",@"wbracket@gmail.com"] atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0,4)]];

            [self getUserPictures];
            [self.searchTableView reloadData];
            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

        }else{
            //        [self.searchTableView reloadData];
            //        [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        
    }
    

    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userFollowingFullName.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.userFollowingFullName.count) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_searchTableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    // create a custom label:                                        x    y   width  height
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 0.0, 240.0, 40.0)];
    [_descriptionLabel setTag:1];
    [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    [_descriptionLabel setFont:[UIFont systemFontOfSize:16.0]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:_descriptionLabel];
    if (_userFollowingFullName && _userFollowingFullName.count) {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.userFollowingFullName[indexPath.row]];
    }
    
    
    if (_userFollowingPictureUrl && _userFollowingPictureUrl.count) {
        
            _userPicUrl = _userFollowingPictureUrl[indexPath.row];
            [[[AsyncImageDownloader alloc] initWithMediaURL:_userPicUrl successBlock:^(UIImage *image)  {
                
                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
                imv.image=image;
                [imv.layer setCornerRadius:imv.frame.size.width/2];
                [imv setClipsToBounds:YES];
                [cell.contentView addSubview:imv];
                
            } failBlock:^(NSError *error) {
                //        NSLog(@"Failed to download image due to %@!", error);
            }] startDownload];
        
//        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(q, ^{
//            /* Fetch the image from the server... */
//            NSURL *url = [NSURL URLWithString:_userPicUrl];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            UIImage *img = [[UIImage alloc] initWithData:data];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                /* This is the main thread again, where we set the tableView's image to
//                 be what we just fetched. */
//                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
//                imv.image=img;
//                [imv.layer setCornerRadius:imv.frame.size.width/2];
//                [imv setClipsToBounds:YES];
//                [cell.contentView addSubview:imv];
//            });
//        });
    }else{
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
        imv.image=nil;
        imv.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:imv];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.lastSelected==indexPath) return; // nothing to do
    //
    //    // deselect old
    //    UITableViewCell *old = [locationTableView cellForRowAtIndexPath:self.lastSelected];
    //    old.accessoryType = UITableViewCellAccessoryNone;
    //    old.backgroundColor = [UIColor blackColor];
    //    [old setSelected:FALSE animated:TRUE];
    //
    //    // select new
    //    UITableViewCell *cell = [locationTableView cellForRowAtIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    cell.backgroundColor = [UIColor purpleColor];
    //    [cell setSelected:TRUE animated:TRUE];
    
    // keep track of the last selected cell
    self.lastSelected = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _userFullNameSelected = _userFollowingFullName[indexPath.row];
    NSLog(@"%@",_userFullNameSelected);
    if ([_userFullNameSelected isEqualToString:@"          No users found."]) {
        _userPicUrlSelected = nil;

    }else{
        _userEmailSelected = _userFollowingEmail[indexPath.row];
//        if (_userFollowingPictureUrl.count>=indexPath.row) {
//            _userPicUrlSelected = _userFollowingPictureUrl[indexPath.row];
//
//        }
        [self userDidSelectUser];
        
    }
    
//    [_searchTableView reloadData];
    
}

- (void)userDidSelectUser
{
    BDViewController2 *media = [[BDViewController2 alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullNameSelected;
    media.userEmail = _userEmailSelected;
//    if (_userFollowingPictureUrl.count==_userFollowingFullName.count) {
//        media.userPicUrl = _userPicUrlSelected;
//    }
    [self.navigationController pushViewController:media animated:YES];
}

- (void)backAction
{
    NSLog(@"BACK BUTTON");
}

- (void)getUserPictures
{
    if (j<_userFollowingEmail.count) {
        
        _userEmail = _userFollowingEmail[j];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                NSArray *results_array = [NSArray arrayWithArray:results];
                if (results_array && results_array.count) {
                    //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                    _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    [_userFollowingPictureUrl addObject:_userPicUrl];
                    
                    j=j+1;
                    [self getUserPictures];
                }else{
                    [_userFollowingPictureUrl addObject:@"http://s25.postimg.org/4qq1lj6nj/minion.jpg"];
                    
                    j=j+1;
                    [self getUserPictures];
                }

            }else{
                [_userFollowingPictureUrl addObject:@"http://s25.postimg.org/4qq1lj6nj/minion.jpg"];
                
                j=j+1;
                [self getUserPictures];
            }
        }];

    }
    if (j==_userFollowingEmail.count) {
        
//        NSLog(@"array = %@",_userFollowingPictureUrl);
        [self.searchTableView reloadData];
        [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];
//    NSLog(@"* * * * * * * * *ViewControllerBase touchesBegan");
//
//    
//    if (![[touch view] isKindOfClass:[UITextField class]]) {
//        [self.view endEditing:YES];
//    }
//    [super touchesBegan:touches withEvent:event];
//}



@end
