//
//  MMHTTPManager.h
//  TwiterDemo
//
//  Created by Mia on 5/12/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMHTTPManagerDelegate <NSObject>

- (void)didReceiveSearchResults:(NSMutableArray *)searchResults;

- (void)failedToReceiveSearchResults:(NSError *)error;

@end

@interface MMHTTPManager : NSObject

@property (nonatomic, weak) id<MMHTTPManagerDelegate> delegate;

+ (MMHTTPManager *)sharedManager;

- (void)startSearchWithSearchText:(NSString *)searchText;

@end
