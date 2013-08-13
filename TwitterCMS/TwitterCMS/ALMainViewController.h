//
//  ALMainViewController.h
//  TwitterCMS
//
//  Created by Jeff L on 8/9/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


- (IBAction)search:(id)sender;
- (IBAction)hiddenDismissKeyboard:(id)sender;




@end
