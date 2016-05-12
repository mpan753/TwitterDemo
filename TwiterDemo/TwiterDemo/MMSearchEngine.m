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

@interface MMSearchEngine ()

@property (nonatomic, strong) MMHTTPManager *httpNetwork;

@end

@implementation MMSearchEngine

CRManager(MMSearchEngine);

- (instancetype)init {
    if (self = [super init]) {
        self.httpNetwork = [MMHTTPManager sharedManager];
    }
    return self;
}

- (void)startTwitterSearchWithSearchText:(NSString *)searchText {
    [self.httpNetwork startSearchWithSearchText:searchText];
}

@end
