//
//  ALTwitterSearchViewController.m
//  TwitterCMS
//
//  Created by Jeff L on 8/2/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALTwitterSearchViewController.h"
#import "ALTwitterCMSApiClient.h"
#import "ALTweetCollectionViewCell.h"
#import "AFNetworking.h"

#define TWEET_COUNT 10

@interface ALTwitterSearchViewController ()

@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSString *nextResultsUrl;
@property (strong, nonatomic) NSString *refreshUrl;

@end

@implementation ALTwitterSearchViewController


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
    
    //loading indicator
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView startAnimating];
    
    //refresh  control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor grayColor]];
    [refreshControl addTarget:self action:@selector(refreshTweets:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    [self.collectionView addSubview:refreshControl];
    [self.view addSubview:activityView];
    
    [self searchTwitter:self.searchTerm withCount:TWEET_COUNT withActiveIndicator: activityView];
}

-(void)refreshTweets: (id)sender {
//    NSArray *urlComponents = [self.nextResultsUrl componentsSeparatedByString:@"?"];
//    urlComponents = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
//    NSMutableDictionary *queryString = [[NSMutableDictionary alloc] init];
//    
//    for (NSString *keyValuePair in urlComponents) {
//        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
//        NSString *key = [pairComponents objectAtIndex:0];
//        NSString *value = [[pairComponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        [queryString setObject:value forKey:key];
//    }
//    
//    NSLog(@"%@", queryString);
//    
//    [[ALTwitterCMSApiClient sharedInstance]
//     getPath:@"search"
//     parameters:queryString
//     success:^(AFHTTPRequestOperation *operation, id JSON) {
//         NSLog(@"%@", JSON);
//         if( [JSON objectForKey:@"success"] ) {
//             NSArray *results = [(NSDictionary *) JSON objectForKey:@"results"];
//             NSArray *search_metadata = [(NSDictionary *) results objectForKey:@"search_metadata"];
//             
//             self.tweets = [(NSDictionary *) results objectForKey:@"statuses"];
//             self.nextResultsUrl = [(NSDictionary *) search_metadata objectForKey:@"next_results"];
//             self.refreshUrl = [(NSDictionary *) search_metadata objectForKey:@"refresh_url"];
    
             if ( [sender isKindOfClass:[UIRefreshControl class]] ) {
                 [(UIRefreshControl *) sender endRefreshing];
             }
             
//             [self.collectionView reloadData];
//         }
//     }
//     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error!");
//         NSLog(@"%@", error);
//     }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tweets count] ? [self.tweets count] : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALTweetCollectionViewCell *tweetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweetCell" forIndexPath:indexPath];
    
    NSDictionary *tweet = [self.tweets objectAtIndex:[indexPath row]];
    NSDictionary *user  = [tweet objectForKey:@"user"];
    
    NSURL *profileImageUrl = [[NSURL alloc] initWithString:[user objectForKey:@"profile_image_url"]];
    NSString *userName = [[NSString alloc] initWithFormat:@"@%@", [user objectForKey:@"screen_name"]];
    NSString *status = [tweet objectForKey:@"text"];
    
    [tweetCell.avatar setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [tweetCell.userName setText: userName];
    [tweetCell.status setText:[tweet objectForKey:@"text"]];
    
    CGSize maxStatusSize = CGSizeMake(230.0f, MAXFLOAT);
    CGSize expectedStatusSize = [status sizeWithFont:tweetCell.status.font constrainedToSize:maxStatusSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect statusFrame = tweetCell.status.frame;
    
    statusFrame.size.height = expectedStatusSize.height;
    tweetCell.status.frame = statusFrame;
    
    
    [tweetCell.status sizeToFit];
    
    
    return tweetCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tweet = [self.tweets objectAtIndex:[indexPath row]];
    NSString *status = [tweet objectForKey:@"text"];
    
    CGFloat width = 310.0f;
    CGSize toSize = {width, MAXFLOAT};
    
    CGSize labelSize = [status sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:toSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return CGSizeMake(width, labelSize.height + 60);
}

- (void)searchTwitter:(NSString *)query withCount:(int)count withActiveIndicator:(UIActivityIndicatorView *)indicator {
    //NSLog(@"%i", count);
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            query, @"q",
                            [NSNumber numberWithInt:count], @"count", nil];
    
    [[ALTwitterCMSApiClient sharedInstance]
     getPath:@"search"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id JSON) {
         if( [JSON objectForKey:@"success"] ) {
             NSArray *results = [(NSDictionary *) JSON objectForKey:@"results"];
             NSArray *search_metadata = [(NSDictionary *) results objectForKey:@"search_metadata"];
             
             self.tweets = [(NSDictionary *) results objectForKey:@"statuses"];
             self.nextResultsUrl = [(NSDictionary *) search_metadata objectForKey:@"next_results"];
             self.refreshUrl = [(NSDictionary *) search_metadata objectForKey:@"refresh_url"];
             
             if ( [indicator isKindOfClass:[UIActivityIndicatorView class]] ) {
                 [indicator stopAnimating];
             }
             
             [self.collectionView reloadData];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error!");
         NSLog(@"%@", error);
     }
     ];
}

- (void)handleLayoutUpdate {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
