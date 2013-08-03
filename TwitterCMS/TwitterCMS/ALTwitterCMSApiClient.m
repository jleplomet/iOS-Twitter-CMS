//
//  ALTwitterCMSApiClient.m
//  TwitterCMS
//
//  Created by Jeff L on 8/2/13.
//  Copyright (c) 2013 Avatarlabs. All rights reserved.
//

#import "ALTwitterCMSApiClient.h"
#import "AFNetworking.h"

#define APIBaseURLString @"http://localhost:8000/api/v1/"
#define APIToken @"eyJpdiI6IlJJMG1WbW9hV0hnbUxDdEdSTzJac1wvMEdFXC9paVZsTGMrZFFsVTYxVGhXND0iLCJ2YWx1ZSI6Ikk4b2ZZU2VoSTUwRlFMRE9lQk0wUUdvaVdFcmVyMFN4bk91WUF0cjNUUWgwMVk5Z3gzQXY1SVY1ekJlNGhSajduNUlkSkI2S0pXMnBTMTRreWxSclM2YUd5RlNSN1wvbjQ4XC8yWm50YlNQUjYxTFBCcE1Sb0grR0NvcXlPTzk1QjdDNExpcEY0YVpxQzNKelFuaTlpNmlHMlBCXC9NeWRKSEVTZHliK0lYUXZiTT0iLCJtYWMiOiI0MjEwYzE0Y2UzNWQ4NzYwYThjZjllN2ZkNTJiOTVjNjc2OTRhOWViNjQzZjI3MWE1ZTM3ZTQ3NTdmZjZlM2M5In0="

@implementation ALTwitterCMSApiClient

+(id)sharedInstance {
    static ALTwitterCMSApiClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ALTwitterCMSApiClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
    });
    
    return __sharedInstance;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        [self setDefaultHeader:@"X-Auth-Token" value:APIToken];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
    }
    
    return self;
}
    
@end
