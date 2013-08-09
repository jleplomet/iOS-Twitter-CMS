//
//  ALTweet.h
//  TwitterCMS
//
//  Created by Jeff L on 8/7/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTweet : NSObject

@property NSNumber *tweetId;
@property NSString *text;
@property NSDate   *createdAt;
@property NSString *userAvatar;
@property NSString *user;

@end
