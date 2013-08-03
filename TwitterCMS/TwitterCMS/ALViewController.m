//
//  ALViewController.m
//  TwitterCMS
//
//  Created by Jeff L on 8/2/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALViewController.h"
#import "ALTwitterCMSApiClient.h"
#import "ALTwitterSearchViewController.h"

#define TWEET_COUNT 10

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search:(id)sender {
    NSLog(@"%@", [self.searchField text]);
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"searchTwitter"]) {
        ALTwitterSearchViewController *tvc = [segue destinationViewController];
        [tvc setSearchTerm:[self.searchField text]];
    }
}

@end
