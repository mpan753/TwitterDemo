//
//  TwitterResult.h
//  TwiterDemo
//
//  Created by Mia on 5/13/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterResult : NSObject

@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * date;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
