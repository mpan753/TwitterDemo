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
#import <Accounts/Accounts.h>

@interface MMHTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) NSURL *baseURLString;
@property (nonatomic,strong) ACAccountStore *accountStore;

@end

@implementation MMHTTPManager

CRManager(MMHTTPManager);

- (instancetype)init {
    if (self = [super init]) {
        self.httpManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (NSString *)baseURLString {
//    return [NSURL URLWithString:@"https://twitter.com/"];
    return @"https://api.twitter.com/1.1/search/tweets.json";
}

- (NSString *)URLString {
    NSString *searchText = [[NSUserDefaults standardUserDefaults] valueForKey:@"searchText"];
    searchText = AFPercentEscapedStringFromString(searchText);
    NSString *query = AFQueryStringFromParameters(@{@"q": searchText});
    
    return [self.baseURLString.mutableCopy stringByAppendingString:[NSString stringWithFormat:@"?%@", query]];
}

- (ACAccountStore *)accountStore
{
    if (_accountStore == nil) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

- (void)startSearchWithSearchText:(NSString *)searchText {
    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    searchText = AFPercentEscapedStringFromString(searchText);
//    NSString *query = AFQueryStringFromParameters(@{@"q": searchText});
    

    
    ACAccountType *acountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:acountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            
//            NSLog(@"%@", query);
            //    [self.httpManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            NSLog(@"Request: %@", self.httpManager.requestSerializer.HTTPRequestHeaders);
            [self.httpManager GET:[self URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"responseObject:%@", responseString);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSLog(@"err:%@",errResponse);
            }];
            
        }
    }];
    
}

@end
