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
#import "Defines.h"
#import <Accounts/Accounts.h>
#import "STTwitter.h"
#import "SBJson4.h"
#import "TwitterResult.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface MMHTTPManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) NSURL *baseURLString;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSMutableArray *twitterSearchResults;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *geoCode;

@end

@implementation MMHTTPManager

CRManager(MMHTTPManager);

- (instancetype)init {
    if (self = [super init]) {
        self.httpManager = [AFHTTPSessionManager manager];
    
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (NSString *)baseURLString {
    return @"https://api.twitter.com/1.1/search/tweets.json";
}

- (NSString *)URLString {
    NSString *searchText = [[NSUserDefaults standardUserDefaults] valueForKey:@"searchText"];
//    searchText = AFPercentEscapedStringFromString(searchText);
    NSString *query = AFQueryStringFromParameters(@{@"q": searchText});
    
    return [self.baseURLString.mutableCopy stringByAppendingString:[NSString stringWithFormat:@"?%@", query]];
}

- (NSMutableArray *)twitterSearchResults {
    if (!_twitterSearchResults) {
        _twitterSearchResults = [@[] mutableCopy];
    }
    return _twitterSearchResults;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)startSearchWithSearchText:(NSString *)searchText {
    
    [self.twitterSearchResults removeAllObjects];
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:CONSUMERKEY consumerSecret:CONSUMERSECRET];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [self.twitter getSearchTweetsWithQuery:searchText geocode:self.geoCode lang:nil locale:nil resultType:nil count:nil until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
            [self parseDataFromResponse:statuses];
            [self.delegate didReceiveSearchResults:self.twitterSearchResults];
        } errorBlock:^(NSError *error) {
            [self.delegate failedToReceiveSearchResults:error];
        }];
    
    } errorBlock:^(NSError *error) {
        [self.delegate failedToReceiveSearchResults:error];
    }];
    
}

- (void)parseDataFromResponse:(NSArray *)statuses{
    
    for (NSDictionary *userDict in statuses) {
        
        TwitterResult *tweetResult = [[TwitterResult alloc] initWithDictionary:userDict];
        [self.twitterSearchResults addObject:tweetResult];

    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [self.location coordinate];
    NSNumber *radius = @(1);
    self.geoCode = [NSString stringWithFormat:@"%f,%f,%@mi", coordinate.latitude, coordinate.longitude, radius];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
}

@end
