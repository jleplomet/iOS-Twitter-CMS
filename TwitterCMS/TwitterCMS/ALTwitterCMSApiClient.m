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
#define APIToken @"eyJpdiI6IlNuMUx2YUJ0emptUDRGdWJLTURIbHVlQmhaN0JcL2k2c044R1NFa2JFNyswPSIsInZhbHVlIjoiVnA2a0ZWUlVVeTF0cElXeTZJbXlLVEVzYlJQa0ZiQ2hjMVlMdFRGclJqOElYSXMrXC95aklVbDB2SlRtbU5lSHNiRzcwNDdvNWt0ZVY5b0pRVjJiV2xmOTh1Vzc4aXF2MVFhZ1UxUTFnUHFESUpBMVNLYjF3Z1FaR2E5S3JvOGRYVmlQWXpueXdWM2pwYWFBQnFFamZQakhla29HODFROTJibGpZbzR0aHk0OD0iLCJtYWMiOiIxMDUyNTE0NDE1YjFlYTk3N2ZkMjE1ZjViZDQ2NWYzYTY2YzQxYjQwYjI4YWM4YzYyOWUxMzEzZTBiYWQ5NDU2In0="

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
