//
//  MMSearchEngine.h
//  TwiterDemo
//
//  Created by Mia on 5/12/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMSearchEngineDelegate <NSObject>

- (void)searchText:(NSString *)searchText twitterSearchDidFailed:(NSInteger *)errorCode;

- (void)searchText:(NSString *)searchText twitterSearchDidSucceed:(NSArray *)searchResults;

@end

@interface MMSearchEngine : NSObject

@property (nonatomic, weak) id<MMSearchEngineDelegate> delegate;
@property (nonatomic, strong) NSArray *searchResults;

+ (MMSearchEngine *)sharedManager;

- (void)startTwitterSearchWithSearchText:(NSString *)searchText;

@end
