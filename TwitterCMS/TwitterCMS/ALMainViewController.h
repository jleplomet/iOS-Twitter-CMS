//
//  ALMainViewController.h
//  TwitterCMS
//
//  Created by Jeff L on 8/9/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)search:(id)sender;
- (IBAction)hiddenDismissKeyboard:(id)sender;

@end
