//
//  YookaSearchLandingViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 4/5/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaSearchLandingViewController.h"
#import "YookaSearchViewController.h"
#import "YookaLocationViewController.h"
#import "YookaLocation2ViewController.h"

@interface YookaSearchLandingViewController ()

@end

@implementation YookaSearchLandingViewController

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
    
    UIColor * color2 = [UIColor colorWithRed:244/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f];
    [self.view setBackgroundColor:color2];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    [_searchTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:_searchTableView];
    
    _searchContent = [NSMutableArray new];
    _searchContent = [NSMutableArray arrayWithArray:@[@"Restaurants",@"Users"]];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchContent.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchContent.count) {
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
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    // create a custom label:                                        x    y   width  height
//    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 0.0, 240.0, 40.0)];
//    [_descriptionLabel setTag:1];
//    [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
//    _descriptionLabel.textColor = [UIColor grayColor];
//    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
//    [_descriptionLabel setFont:[UIFont systemFontOfSize:16.0]];
//    // custom views should be added as subviews of the cell's contentView:
//    [cell.contentView addSubview:_descriptionLabel];
//    
//    [(UILabel *)[cell.contentView viewWithTag:1] setText:self.searchContent[indexPath.row]];
    
    cell.textLabel.text = self.searchContent[indexPath.row];
    
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
    
    if ([_searchContent[indexPath.row] isEqualToString:@"Restaurants"]) {
        [self userDidSelectRestaurant];
    }
    
    if ([_searchContent[indexPath.row] isEqualToString:@"Users"]) {
        [self userDidSelectUser];
    }
    
    [_searchTableView reloadData];
    
}



- (void)userDidSelectUser
{
    YookaSearchViewController *media = [[YookaSearchViewController alloc]init];
    [self.navigationController pushViewController:media animated:YES];
}

- (void)userDidSelectRestaurant
{
    YookaLocation2ViewController *media = [[YookaLocation2ViewController alloc]init];
    [self.navigationController pushViewController:media animated:YES];
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
