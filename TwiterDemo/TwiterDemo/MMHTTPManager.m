//
//  MMHTTPManager.m
//  TwiterDemo
//
//  Created by Mia on 5/12/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "MMHTTPManager.h"
#import "AFNetworking.h"
#import "Utility.h"

@interface MMHTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) NSURL *baseURL;

@end

@implementation MMHTTPManager

CRManager(MMHTTPManager);

- (instancetype)init {
    if (self = [super init]) {
        self.httpManager = [[AFHTTPSessionManager manager] initWithBaseURL:self.baseURL];
    }
    return self;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://www.googto.net/"];
}

- (void)startSearchWithSearchText:(NSString *)searchText {
    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *query = AFQueryStringFromParameters(@{@"q": searchText});
    
    NSLog(@"%@", query);
    [self.httpManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    NSLog(@"Request: %@", self.httpManager.requestSerializer.HTTPRequestHeaders);
    [self.httpManager GET:[NSString stringWithFormat:@"?%@", query] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseObject:%@", responseString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"err:%@",errResponse);
    }];
}

@end
