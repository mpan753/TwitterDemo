//
//  MMHTTPManager.h
//  TwiterDemo
//
//  Created by Mia on 5/12/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMHTTPManager : NSObject

+ (MMHTTPManager *)sharedManager;

- (void)startSearchWithSearchText:(NSString *)searchText;

@end
