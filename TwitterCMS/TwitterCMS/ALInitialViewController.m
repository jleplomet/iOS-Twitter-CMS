//
//  ALInitialViewController.m
//  TwitterCMS
//
//  Created by Jeff L on 8/9/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALInitialViewController.h"

@interface ALInitialViewController ()

@end

@implementation ALInitialViewController

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
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    
    [self.navigationItem setTitle:@"Twitter CMS"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
