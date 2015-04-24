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
    
//    NSString *huntURLString = @"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=allHunts";
    NSString *huntURLString = @"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=huntsWithImage";
    

    
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

//    enum {IMAGE_VIEW_TAG = 20, MAIN_VIEW_TAG = 50, LABEL_TAG = 30};
    
    
    
    Hunt *hunt = [self.huntDataSource huntAtIndex:(long)rowIndex];
    // Configure the cell...
    
//    UIView *view = [cell viewWithTag: MAIN_VIEW_TAG];
    
//    if( view ) {
//        UIImageView *iv = (UIImageView *)[view viewWithTag: IMAGE_VIEW_TAG];
//        NSArray *views = [iv subviews];
//        for( UIView *v in views )
//            [v removeFromSuperview];
//        iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[hunt getImageURL]]]];
    
//        UILabel *aLabel = (UILabel *) [view viewWithTag: LABEL_TAG];
//        aLabel.attributedText = [hunt descriptionForListEntry];
//        return cell;
//    }
    
//    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
//    CGRect viewFrame = CGRectMake(0, 0, bounds.size.width, MOVIE_VIEW_HEIGHT);
    
//    UIView *thisView = [[UIView alloc] initWithFrame: viewFrame];
    
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[hunt getImageURL]]]];
//    CGRect imgFrame = CGRectMake(10, (viewFrame.size.height - IMAGE_HEIGHT) / 2, IMAGE_WIDTH, IMAGE_HEIGHT );
//    UIImageView *iView = [[UIImageView alloc] initWithImage: img];
//    iView.tag = IMAGE_VIEW_TAG;
//    iView.frame = imgFrame;
//    [thisView addSubview: iView];
    
//    UILabel *movieInfoLabel = [[UILabel alloc]
//                               initWithFrame:CGRectMake(IMAGE_WIDTH + 2 * 10, 5,
//                                                        viewFrame.size.width - IMAGE_WIDTH - 10,
//                                                        viewFrame.size.height -5)];
    
    cell.textLabel.text = [hunt title];
//    cell.textLabel.textColor = [UIColor blackColor];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.layer.opacity = 1.0;

    NSString *date = [hunt getDate];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = date;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog( @"%@", [hunt title] );
    
//    movieInfoLabel.tag = LABEL_TAG;
//    NSAttributedString *desc = [movie descriptionForListEntry];
//    movieInfoLabel.attributedText = desc;
//    movieInfoLabel.numberOfLines = 0;
//    [thisView addSubview: movieInfoLabel];
//    thisView.tag = MAIN_VIEW_TAG;
//    [[cell contentView] addSubview:thisView];
    
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
//    svc.huntName = [hunt title];
    svc.hunt = hunt;
    
    
    [self.navigationController pushViewController:svc animated:YES];
    
}



@end
