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
//    return [NSURL URLWithString:@"https://twitter.com/"];
    return @"https://api.twitter.com/1.1/search/tweets.json";
}

- (NSString *)URLString {
    NSString *searchText = [[NSUserDefaults standardUserDefaults] valueForKey:@"searchText"];
    searchText = AFPercentEscapedStringFromString(searchText);
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
    }
    return _locationManager;
}

/*- (ACAccountStore *)accountStore
{
    if (_accountStore == nil) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}
 */

- (void)startSearchWithSearchText:(NSString *)searchText {
//    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    searchText = AFPercentEscapedStringFromString(searchText);
//    NSString *query = AFQueryStringFromParameters(@{@"q": searchText});
    [self.twitterSearchResults removeAllObjects];
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e7Mhw0VZVIlYCX99Vp2YXIsxP" consumerSecret:@"F4IfLlNSsxbsAMe0frPFb6X90PWtjDzK5LVLP7NT4pO1XMR1i0"];
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        
        
        [self.twitter getSearchTweetsWithQuery:searchText geocode:nil lang:nil locale:nil resultType:nil count:nil until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
//            NSLog(@"success:%@", statuses);
            [self parseDataFromResponse:statuses];
            [self.delegate didReceiveSearchResults:self.twitterSearchResults];
        } errorBlock:^(NSError *error) {
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSLog(@"err:%@",errResponse);
        }];
        /*
        [self.twitter getSearchTweetsWithQuery:searchText successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
            NSLog(@"success:%@", statuses);
        } errorBlock:^(NSError *error) {
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSLog(@"err:%@",errResponse);
        }];
         */
    } errorBlock:^(NSError *error) {
        
    }];
    
    
    /*
    ACAccountType *acountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:acountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            
//            NSLog(@"%@", query);
            NSLog(@"Request: %@", self.httpManager.requestSerializer.HTTPRequestHeaders);
            [self.httpManager GET:[self URLString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"responseObject:%@", responseString);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSLog(@"err:%@",errResponse);
            }];
            
        }
    }];*/
    
}

- (void)parseDataFromResponse:(NSArray *)statuses{
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    for (NSDictionary *userDict in statuses) {
        
        TwitterResult *tweetResult = [[TwitterResult alloc] initWithDictionary:userDict];
        [self.twitterSearchResults addObject:tweetResult];

    }
    
//    if ([appDelegate.managedObjectContext hasChanges]) {
//        NSError *saveErr;
//        [appDelegate.managedObjectContext save:&saveErr];
//    }
}

- (CLLocationCoordinate2D)getLocation {
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSLog(@"*dLatitude : %@", latitude);
    NSLog(@"*dLongitude : %@",longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
//    [self presentViewController:alertController animated:YES completion:nil];
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

@end
