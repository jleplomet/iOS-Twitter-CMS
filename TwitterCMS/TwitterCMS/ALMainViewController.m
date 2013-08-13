//
//  ALMainViewController.m
//  TwitterCMS
//
//  Created by Jeff L on 8/9/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALMainViewController.h"
#import "ECSlidingViewController.h"
#import "ALMenuViewController.h"
#import "ALTwitterSearchResultsViewController.h"
#import "ALCMSTweetCollectionViewCell.h"
#import "ALTweet.h"
#import "NSDate+TimeAgo.h"
#import "ALTwitterCMSApiClient.h"


@interface ALMainViewController ()

@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSString *nextResults;
@property (strong, nonatomic) NSString *refreshUrl;

@end

@implementation ALMainViewController



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
    
    //NSLog(@"viewDidLoad");
    
    self.tweets = [[NSMutableArray alloc] init];
    
    [self.navigationItem setTitle:@"Twitter CMS"];
    
	// Do any additional setup after loading the view.
    
//    self.view.layer.shadowOpacity = 0.75f;
//    self.view.layer.shadowRadius = 10.0f;
//    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
//    
//    [self.segmentedServiceControl addTarget:self action:@selector(selectServiceToSearch:) forControlEvents:UIControlEventValueChanged];
//    
//    
//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[ALMenuViewController class]]) {
//        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
//    }
//    
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //[self.searchField becomeFirstResponder];
    
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    [self.collectionView setAlwaysBounceVertical:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
    
    [self getApprovedTweets];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.tweets removeAllObjects];
    [self.searchField resignFirstResponder];
}

-(void)getApprovedTweets {
    [self callTwitterApi:@"cms" withParams:nil withActiveIndicator:[self displayLoadingIndicator]];
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


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tweets count] ? [self.tweets count] : 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ALTweet *tweet = [self.tweets objectAtIndex:[indexPath row]];
    NSString *status = [tweet text];
    
    CGFloat width = 310.0f;
    CGSize toSize = {width, MAXFLOAT};
    
    CGSize labelSize = [status sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:toSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return CGSizeMake(width, labelSize.height + 60);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALCMSTweetCollectionViewCell *tweetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"approvedTweetCell" forIndexPath:indexPath];
    
    ALTweet *tweet = [self.tweets objectAtIndex:[indexPath row]];
    [tweetCell setTweet:tweet];
    
    return tweetCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALTweet *tweet = [self.tweets objectAtIndex:[indexPath row]];
    
    NSLog(@"tweetId: %@ user: %@", [tweet tweetId], [tweet user]);
    
    NSString *requestParams = [[NSString alloc] initWithFormat:@"?id=%@&tweetId=%@", [tweet id], [tweet tweetId]];
    
    NSLog(@"%@", requestParams);
    
    NSMutableDictionary *params = [self buildRequestParameters:requestParams];
    
    [self postToTwitterCMSApi:@"cms/updatetweet" withParams:params];
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

- (void)callTwitterApi:(NSString *)path withParams:(NSMutableDictionary *)params withActiveIndicator:(UIActivityIndicatorView *)indicator {
    [[ALTwitterCMSApiClient sharedInstance]
     getPath:path parameters:params
     success:^(AFHTTPRequestOperation *operation, id JSON) {
         if( [JSON objectForKey:@"success"] ) {
             //NSLog(@"%@", JSON);
             
             NSArray *results = [(NSDictionary *) JSON objectForKey:@"results"];
             
             if (![results count]) {
                 [self destoryLoadingIndicator:indicator];
                 
                 return;
             }
             
             for (id status in results) {
                 //build tweet cell object
                 ALTweet *tweet = [[ALTweet alloc] init];
                 
                 NSString *id_str = [status objectForKey:@"tweetId"];
                 
                 [tweet setId:[status objectForKey:@"id"]];
                 [tweet setTweetId:id_str];
                 [tweet setText:[status objectForKey:@"text"]];
                 [tweet setUserAvatar:[status objectForKey:@"avatar"]];
                 [tweet setUser:[status objectForKey:@"user"]];
                 
                 [tweet setTweetStatus:[status objectForKey:@"status"]];
                 
                 [self.tweets addObject:tweet];
             }
             
             [self destoryLoadingIndicator:indicator];
             
             //sort by created_at
             NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweetId" ascending:NO];
             [self.tweets sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
             
             [self.collectionView reloadData];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //
         NSLog(@"Error!");
         NSLog(@"%@", error);
     }
     ];
}

- (void)postToTwitterCMSApi:(NSString *)path withParams:(NSMutableDictionary *)params {
    [[ALTwitterCMSApiClient sharedInstance]
     postPath:path
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id JSON) {
         //
         NSLog(@"%@", JSON);
         
         NSDictionary *results = [(NSDictionary *) JSON objectForKey:@"tweet"];
         
         for (ALTweet *tweet in self.tweets) {
             //
             NSLog(@"tweet.tweetId: %@ JSON.id %@", tweet.tweetId, [results objectForKey:@"tweetId"]);
             
             if ([tweet.tweetId isEqualToString:[results objectForKey:@"tweetId"] ]) {
                 //NSLog(@"found tweet with id: %@", [results objectForKey:@"id"]);
                 
                 [tweet setTweetStatus:[results objectForKey:@"status"]];
             }
         }
         
         [self.collectionView reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //
         NSLog(@"Error!");
         NSLog(@"%@", error);
     }];
}

-(void)selectServiceToSearch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    NSLog(@"Segment clicked: %@", [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
}

-(void)dismissKeyboard {
    [self.searchField resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"searchTwitter"]) {
        ALTwitterSearchResultsViewController *tvc = [segue destinationViewController];
        [tvc setSearchTerm:[self.searchField text]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search:(id)sender {
    [self.searchField resignFirstResponder];
}

- (IBAction)hiddenDismissKeyboard:(id)sender {
    [self dismissKeyboard];
}
@end
