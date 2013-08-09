//
//  ALTwitterSearchViewController.m
//  TwitterCMS
//
//  Created by Jeff L on 8/2/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALTwitterSearchResultsViewController.h"
#import "ALTwitterCMSApiClient.h"
#import "ALTweetCollectionViewCell.h"
#import "AFNetworking.h"
#import "ALTweet.h"
#import "NSDate+TimeAgo.h"

#define TWEET_COUNT 10

@interface ALTwitterSearchResultsViewController ()

@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSString *nextResults;
@property (strong, nonatomic) NSString *refreshUrl;

@end

@implementation ALTwitterSearchResultsViewController

bool loadFromBottom = NO;
bool refreshing = YES; //set for now so we can store the stupid refresh url...
bool firstLoad = YES;


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
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tweets = [[NSMutableArray alloc] init];
    
    //refresh  control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor grayColor]];
    [refreshControl addTarget:self action:@selector(refreshTweets:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    [self.collectionView addSubview:refreshControl];
    
    //set navbar title
    NSString *navBarTitle = [[NSString alloc] initWithFormat:@"%@", self.searchTerm, nil];
    
    [self.navigationItem setTitle: navBarTitle];
    
    [self.collectionView reloadData];
    
    [self getInitialTweets];
}



-(void)getInitialTweets {
    //setup default params
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   self.searchTerm, @"q",
                                   [NSNumber numberWithInt:TWEET_COUNT], @"count",
                                   nil];
    
    [self callTwitterApi:@"search" withParams:params withActiveIndicator:[self displayLoadingIndicator]];
}

-(void)refreshTweets: (id)sender {
    //NSLog(@"refreshTweets %@", self.nextResults);
    
    refreshing = YES;
    
    NSMutableDictionary *queryString = [self buildRequestParameters:self.refreshUrl];
    //NSLog(@"%@", queryString);
    [self callTwitterApi:@"search/refresh" withParams:queryString withActiveIndicator:sender];
}

-(id)buildRequestParameters:(NSString *)urlString {
    NSMutableDictionary *queryString = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"?"];
    
    urlComponents = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [[pairComponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [queryString setObject:value forKey:key];
    }
    
    return queryString;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tweets count] ? [self.tweets count] : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALTweetCollectionViewCell *tweetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweetCell" forIndexPath:indexPath];
    
    //check if we are not in the last cell
    
    if ( (indexPath.row >= [self.tweets count] - 1) ) {
        NSLog(@"Last Row!");
        UICollectionViewCell *loadingCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loadingCell" forIndexPath:indexPath];
        return loadingCell;
    }
    
    ALTweet *tweet = [self.tweets objectAtIndex:[indexPath row]];
    
    [tweetCell setTweet:tweet];
    
    return tweetCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALTweet *tweet = [self.tweets objectAtIndex:[indexPath row]];
    
    NSLog(@"tweetId: %@ user: %@", [tweet tweetId], [tweet user]);
    
    NSString *requestParams = [[NSString alloc] initWithFormat:@"?tweetId=%@&user=%@&text=%@&created_at=%@&avatar=%@", [tweet tweetId], [tweet user], [tweet text], [tweet createdAt], [tweet userAvatar]];
    
    NSLog(@"%@", requestParams);
    
    NSMutableDictionary *queryString = [self buildRequestParameters:requestParams];
    
    [self postToTwitterCMSApi:@"cms/approve" withParams:queryString];
    
    [self.collectionView performBatchUpdates:^{
        NSArray *itemPaths = [self.collectionView indexPathsForSelectedItems];
        
        //delete from data source...
        [self.tweets removeObjectAtIndex:[indexPath row]];
        
        [self.collectionView deleteItemsAtIndexPaths:itemPaths];
    } completion:nil];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= [self.tweets count] - 1) {
        return CGSizeMake(310.0f, 40);
    }
    
    
    ALTweet *tweet = [self.tweets objectAtIndex:[indexPath row]];
    NSString *status = [tweet text];
    
    CGFloat width = 310.0f;
    CGSize toSize = {width, MAXFLOAT};
    
    CGSize labelSize = [status sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:toSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return CGSizeMake(width, labelSize.height + 60);
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0) {
        //NSLog(@"at the top!");
    }
    else if ( (scrollOffset + scrollViewHeight == scrollContentSizeHeight) && !loadFromBottom )
    {
        loadFromBottom = YES;
        //NSLog(@"at the bottom!");
        
        //parse next_results string and create a params NSDictionary
        NSMutableDictionary *queryString = [self buildRequestParameters:self.nextResults];
        
        //NSLog(@"%@", queryString);
        [self callTwitterApi:@"search/next" withParams:queryString withActiveIndicator:nil];
    }
}

- (void)postToTwitterCMSApi:(NSString *)path withParams:(NSMutableDictionary *)params {
    [[ALTwitterCMSApiClient sharedInstance]
     postPath:path
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id JSON) {
        //
         NSLog(@"%@", JSON);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
         NSLog(@"Error!");
         NSLog(@"%@", error);
    }];
}

- (void)callTwitterApi:(NSString *)path withParams:(NSMutableDictionary *)params withActiveIndicator:(UIActivityIndicatorView *)indicator {
    
    [[ALTwitterCMSApiClient sharedInstance]
     getPath:path
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id JSON) {
         //NSLog(@"%@", JSON);
         if( [JSON objectForKey:@"success"] ) {
             NSArray *results = [(NSDictionary *) JSON objectForKey:@"results"];
             NSArray *search_metadata = [(NSDictionary *) results objectForKey:@"search_metadata"];
             NSArray *statuses = [(NSDictionary *) results objectForKey:@"statuses"];
             
             //NSLog(@"%@", search_metadata);
             
             //exit out if we do not find any statuses...
             if ( ![statuses count] ) {
                 [self destoryLoadingIndicator:indicator];
                 
                 //TODO: remove this to a reset method?
                 //if we are refreshing just set to false...
                 if (refreshing) {
                     refreshing = NO;
                 }
                 
                 //if we are loading from the bottom, just reset bool to false
                 if (loadFromBottom) {
                     loadFromBottom = NO;
                 }
                 
                 NSLog(@"no statuses at the moment.");
                 
                 //should we call this to update the tweet times?
                 [self.collectionView reloadData];
                 return;
             }
             
             //store refresh_url
             if (refreshing) {
                 self.refreshUrl = [(NSDictionary *) search_metadata objectForKey:@"refresh_url"];
                 
                 //NSLog(@"refresh url: %@ stored refresh url: %@", [(NSDictionary *) search_metadata objectForKey:@"refresh_url"], self.refreshUrl);
                 
                 //since we technally refreshing the first time, go ahead and store the next_results but only if firstLoad = YES
                 if (firstLoad) {
                     //store next_results
                     self.nextResults = [(NSDictionary *) search_metadata objectForKey:@"next_results"];
                     firstLoad = NO; //kill it with fire.
                 }
             }
             //store next_results if we are not refreshing.
             else {
                 //store next_results
                 self.nextResults = [(NSDictionary *) search_metadata objectForKey:@"next_results"];
             }
             
             for (id status in statuses) {
                 //get user object of status
                 NSDictionary *user = [status objectForKey:@"user"];
                 
                 //created_at date format
                 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                 [dateFormat setDateFormat:@"EEE MMM d HH:mm:ss ZZZZ yyyy"];
                 NSDate *created_at = [dateFormat dateFromString:[status objectForKey:@"created_at"]];
                 NSString *id_str = [status objectForKey:@"id_str"];
                 
                 //NSLog(@"tweetId: %@ user: %@", id_str, [user objectForKey:@"screen_name"]);
                 
                 //build tweet cell object
                 ALTweet *tweet = [[ALTweet alloc] init];
                 [tweet setCreatedAt:created_at];
                 [tweet setTweetId: [NSNumber numberWithInt: [id_str intValue]]];
                 [tweet setText:[status objectForKey:@"text"]];
                 [tweet setUserAvatar:[user objectForKey:@"profile_image_url"]];
                 [tweet setUser:[user objectForKey:@"screen_name"]];
                 
                 [self.tweets addObject:tweet];
             }
             
             //kill loading indicator
             [self destoryLoadingIndicator:indicator];
             
             //if we are refreshing just set to false...
             if (refreshing) {
                 refreshing = NO;
             }
             
             //if we are loading from the bottom, just reset bool to false
             if (loadFromBottom) {
                 loadFromBottom = NO;
             }             
             
             //sort by created_at
             NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
             [self.tweets sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
             
             
             
             [self.collectionView reloadData];
             
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error!");
         NSLog(@"%@", error);
     }
     ];
}

-(id)displayLoadingIndicator {
    //loading indicator
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView startAnimating];
    
    [self.view addSubview:activityView];
    
    return activityView;
}

-(void)destoryLoadingIndicator:(id)indicator {
    //kill loading indicator if its kind is UIActivityIndicatorView
    if ([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
        [indicator stopAnimating];
    }
    
    //same as above but check for UIRefreshControl
    if ( [indicator isKindOfClass:[UIRefreshControl class]] ) {
        [(UIRefreshControl *) indicator endRefreshing];
    }
}

- (IBAction)refreshSearchResults:(id)sender {
    [self refreshTweets:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




