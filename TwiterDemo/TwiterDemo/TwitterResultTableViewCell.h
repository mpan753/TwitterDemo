//
//  TwitterResultTableViewCell.h
//  TwiterDemo
//
//  Created by Mia on 5/16/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterResult.h"

@interface TwitterResultTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

- (void)displayTwitterResult:(TwitterResult *)twitterResult;

@end
