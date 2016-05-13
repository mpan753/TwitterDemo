//
//  TwitterResult.m
//  TwiterDemo
//
//  Created by Mia on 5/13/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "TwitterResult.h"

@implementation TwitterResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqual:@"created_at"]) {
        self.date = value;
    } else if ([key isEqual:@"id_str"]) {
        self.userID = value;
    } else if ([key isEqual:@"name"]) {
        self.name = value;
    } else if ([key isEqual:@"text"]) {
        self.text = value;
    }
}

@end
