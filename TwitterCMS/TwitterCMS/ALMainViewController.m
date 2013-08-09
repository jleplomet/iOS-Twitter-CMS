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


@interface ALMainViewController ()

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
	// Do any additional setup after loading the view.
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[ALMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [self.searchField becomeFirstResponder];
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
