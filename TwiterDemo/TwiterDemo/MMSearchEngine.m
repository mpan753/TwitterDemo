//
//  MMSearchEngine.m
//  TwiterDemo
//
//  Created by Mia on 5/12/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "MMSearchEngine.h"
#import "MMHTTPManager.h"
#import "Utility.h"

@interface MMSearchEngine () <MMHTTPManagerDelegate>

@property (nonatomic, strong) MMHTTPManager *httpNetwork;

@end

@implementation MMSearchEngine

CRManager(MMSearchEngine);

- (instancetype)init {
    if (self = [super init]) {
        self.httpNetwork = [MMHTTPManager sharedManager];
        self.httpNetwork.delegate = self;
    }
    return self;
}

- (void)startTwitterSearchWithSearchText:(NSString *)searchText {
    [self.httpNetwork startSearchWithSearchText:searchText];
}

#pragma mark - Getter

- (NSArray *)searchResults {
    if (!_searchResults) {
        _searchResults = @[];
    }
    return _searchResults;
}

#pragma mark - MMHTTPManagerDelegate

- (void)didReceiveSearchResults:(NSMutableArray *)searchResults {
    NSString *searchText = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchText"];
    self.searchResults = searchResults.copy;
    [self.delegate searchText:searchText twitterSearchDidSucceed:self.searchResults];
}

@end
