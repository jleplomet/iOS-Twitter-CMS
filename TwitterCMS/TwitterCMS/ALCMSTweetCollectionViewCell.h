//
//  ALCMSTweetCollectionViewCell.h
//  TwitterCMS
//
//  Created by Jeff L on 8/13/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALTweet.h"

@interface ALCMSTweetCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *status;

-(void)setTweet:(ALTweet *)tweet;

@end
