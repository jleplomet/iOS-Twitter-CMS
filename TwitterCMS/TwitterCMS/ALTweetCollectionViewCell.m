//
//  ALTweetCollectionViewCell.m
//  TwitterCMS
//
//  Created by Jeff L on 8/2/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALTweetCollectionViewCell.h"

@implementation ALTweetCollectionViewCell

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
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 50)];
        self.backgroundView = bg;
        self.backgroundView.backgroundColor = [UIColor lightGrayColor];
        
        UIView *sbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 50)];
        self.selectedBackgroundView = sbg;
        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
        
        
    }
    
    return self;
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
