//
//  ALTwitterSearchViewController.h
//  TwitterCMS
//
//  Created by Jeff L on 8/2/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTwitterSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSString *searchTerm;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
