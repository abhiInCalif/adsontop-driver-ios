//
//  RestLayer.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "RestLayer.h"

@implementation RestLayer

// This will be the general library for REST calls for all the pages in the app.
static NSString * const BaseURLString = @"http://aot-dev.us-west-1.elasticbeanstalk.com/mobile/";
//static NSString * const BaseURLString = @"http://localhost:8000/mobile/";

+(AFHTTPSessionManager*)getDriver:(NSString*)i {
    NSString* fullUrl = [NSString stringWithFormat:@"%@driver/%@/", BaseURLString, i];
    NSURL *baseURL = [NSURL URLWithString:fullUrl];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"akhanna" password:@"aotaotaot"];
    return manager;
}

+(AFHTTPSessionManager*)getCampaign:(NSString*)i {
    NSString* fullUrl = [NSString stringWithFormat:@"%@campaign/%@/", BaseURLString, i];
    NSURL *baseURL = [NSURL URLWithString:fullUrl];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"akhanna" password:@"aotaotaot"];

    return manager;
}

+(AFHTTPSessionManager*)postDriver {
    NSString* fullUrl = [NSString stringWithFormat:@"%@driver/", BaseURLString];
    NSURL *baseURL = [NSURL URLWithString:fullUrl];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"akhanna" password:@"aotaotaot"];
    return manager;
}

+(AFHTTPSessionManager*)postSignal {
    NSString* fullUrl = [NSString stringWithFormat:@"%@signal/", BaseURLString];
    NSURL *baseURL = [NSURL URLWithString:fullUrl];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"akhanna" password:@"aotaotaot"];
    return manager;
}

@end
