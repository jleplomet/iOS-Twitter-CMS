//
//  ALCMSTweetCollectionViewCell.m
//  TwitterCMS
//
//  Created by Jeff L on 8/13/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALCMSTweetCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"

@implementation ALCMSTweetCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}

-(void)setTweet:(ALTweet *)tweet {
    NSDate *createdAt = [tweet createdAt];
    NSURL *profileImageUrl = [[NSURL alloc] initWithString:[tweet userAvatar]];
    
    [self.createdAt setText:[createdAt timeAgo]];
    [self.userName setText:[tweet user]];
    [self.avatar setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:@"default_profile_0_normal.png"]];
    [self.status setText:[tweet text]];
    
    if ([tweet.tweetStatus isEqualToString:@"approved"]) {
        self.backgroundColor = [UIColor greenColor];
    }
    else if ([tweet.tweetStatus isEqualToString:@"rejected"]) {
        self.backgroundColor = [UIColor redColor];
    }
    
    CGSize maxStatusSize = CGSizeMake(230.0f, MAXFLOAT);
    CGSize expectedStatusSize = [[tweet text] sizeWithFont:self.status.font constrainedToSize:maxStatusSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect statusFrame = self.status.frame;
    
    statusFrame.size.height = expectedStatusSize.height + 20;
    self.status.frame = statusFrame;
    
    [self.status sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
