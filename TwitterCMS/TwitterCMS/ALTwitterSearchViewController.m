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

#define TWEET_COUNT 10

@interface ALTwitterSearchViewController ()

@property (strong, nonatomic) NSString *nextResults;

@end

@implementation ALTwitterSearchViewController

NSArray *tweets;
NSArray *searchMetaData;
NSString *nextResults;


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
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView startAnimating];
    
    [self.view addSubview:activityView];
    
    [self searchTwitter:self.searchTerm withCount:TWEET_COUNT withActiveIndicator: activityView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALTweetCollectionViewCell *tweetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tweetCell" forIndexPath:indexPath];
    
    return tweetCell;
}

- (void)searchTwitter:(NSString *)query withCount:(int)count withActiveIndicator:(UIActivityIndicatorView *)indicator {
    NSLog(@"%i", count);
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            query, @"q",
                            [NSNumber numberWithInt:count], @"count", nil];
    
    [[ALTwitterCMSApiClient sharedInstance]
     getPath:@"search"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if( [responseObject objectForKey:@"success"] ) {
             NSArray *searchmetadata = [(NSDictionary *) responseObject objectForKey:@"search_metadata"];
             NSArray *results = [(NSDictionary *) responseObject objectForKey:@"statuses"];
             
             tweets = results;
             searchMetaData = searchmetadata;
             
             if ( [indicator isKindOfClass:[UIActivityIndicatorView class]] ) {
                 [indicator stopAnimating];
             }
             
             [self handleLayoutUpdate];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error!");
         NSLog(@"%@", error);
     }
     ];
}

- (void)handleLayoutUpdate {
    NSDictionary *tweetsInfo = [searchMetaData objectAtIndex:0];
    
    [self.nextResults initWithString:[tweetsInfo objectForKey:@"next_results"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
