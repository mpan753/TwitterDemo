//
//  TwitterResultTableViewCell.m
//  TwiterDemo
//
//  Created by Mia on 5/16/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "TwitterResultTableViewCell.h"

@interface TwitterResultTableViewCell ()



@end

@implementation TwitterResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayTwitterResult:(TwitterResult *)twitterResult {

    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.text = twitterResult.text;
    NSRange range = [self highlightSearchKeywordOnText:twitterResult.text];
    [self highLightSearchTextForRange:range];

}

- (NSRange)highlightSearchKeywordOnText:(NSString *)text {
    NSString *searchText = [[NSUserDefaults standardUserDefaults] valueForKey:@"searchText"];
    return [text rangeOfString:searchText options:NSCaseInsensitiveSearch];
}

- (void)highLightSearchTextForRange:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:47 green:194 blue:254 alpha:1] range:range];
    self.contentLabel.attributedText = attrStr;
}

@end
