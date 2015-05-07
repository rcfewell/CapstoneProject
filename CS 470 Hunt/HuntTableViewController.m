//
//  HuntTableViewController.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "HuntTableViewController.h"

@interface HuntTableViewController ()

@property (nonatomic) HuntDataSource *huntDataSource;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) NSString *hunts;




@end

enum { MOVIE_VIEW_HEIGHT = 90, GAP_BTWN_VIEWS = 5, IMAGE_HEIGHT = 80, IMAGE_WIDTH = 80 };

static NSString *tableCellViewID = @"Cell";

@implementation HuntTableViewController



-(id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSLog( @"in hunts view did load" );
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellViewID];
    
    //This just shows all hunts even if there is no picture associated with it
//    NSString *huntURLString = @"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=allHunts";
    //shows hunts, image and date for hunts that have images
    NSString *huntURLString = @"http://www.cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=huntsWithImage";
    

    
    self.huntDataSource = [[HuntDataSource alloc] initWithHuntsURLString:huntURLString];
    [self.huntDataSource setDelegate:self];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter:self.view.center];
    [self.view addSubview:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"Hunts";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setBackgroundView:imageView];
    self.tableView.backgroundView.alpha = 0.5;
    
                                 
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dataSourceReadyForUse:(HuntDataSource *) dataSource
{
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {    // Return the number of sections.
    if( ! [self.huntDataSource dataReadyForUse] )
    {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidesWhenStopped:YES];
    }
    
    return 1;
}

-(void) refreshTableView: (UIRefreshControl *) sender
{
    [self.tableView reloadData];
    [sender endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSLog(@"Number of rows in the table: %ld", (long)[self.huntDataSource numberOfHunts]);
    
    return [self.huntDataSource numberOfHunts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableCellViewID];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellViewID forIndexPath:indexPath];

    cell = [self huntViewForIndex:[indexPath row] withTableViewCell:cell];
    
    
    return cell;
}

-(UITableViewCell *) huntViewForIndex: (NSInteger) rowIndex withTableViewCell: (UITableViewCell *) cell
{
    
    cell.selectionStyle = UITableViewCellStyleSubtitle;
   
    Hunt *hunt = [self.huntDataSource huntAtIndex:rowIndex];
    // Configure the cell...


   
    cell.textLabel.text = [hunt title];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.opacity = 1.0;

    NSString *date = [hunt getDate];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = date;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.indentationLevel = 1;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[hunt getImageURL]]]];
//    cell.imageView.frame = CGRectMake(0, 0, 32, 32);
//    cell.imageView.layer.cornerRadius = 15.0f;
//    NSLog( @"%@", [hunt title] );
    

    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.huntDataSource deleteHuntAtIndex:[indexPath row]];
    [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Hunt *hunt = [self.huntDataSource huntAtIndex:[indexPath row]];
    self.hunts = [hunt title];
    

    StepViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepViewController"];
    svc.hunt = hunt;
    
    
    [self.navigationController pushViewController:svc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}



@end
