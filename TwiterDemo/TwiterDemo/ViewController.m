//
//  ViewController.m
//  TwiterDemo
//
//  Created by Mia on 5/11/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "ViewController.h"
#import "MMSearchEngine.h"
#import "TwitterResultTableViewCell.h"
#import "TwitterResult.h"
#import "MBProgressHUD.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, MMSearchEngineDelegate>

@property (nonatomic, strong) MMSearchEngine *searchEngine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"TwitterResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchEngine.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwitterResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    TwitterResult *result = self.searchEngine.searchResults[indexPath.row];
    [cell displayTwitterResult:result];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwitterResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TwitterResult *result = self.searchEngine.searchResults[indexPath.row];
    CGFloat contentLabelHeight = [self sizeOfLabel:cell.contentLabel withText:result.text].height;

    if (contentLabelHeight < 45) {
        return 45;
    }
    
    CGFloat combinedHeight = contentLabelHeight + 1;
    
    return combinedHeight;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:searchBar.text forKey:@"searchText"];
    [self.searchEngine startTwitterSearchWithSearchText:searchBar.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view endEditing:YES];
}

- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {

    return [text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
}


#pragma mark - MMSearchEngineDelegate

- (void)searchText:(NSString *)searchText twitterSearchDidSucceed:(NSArray *)searchResults {
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)searchText:(NSString *)searchText twitterSearchDidFailed:(NSInteger )errorCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Search Results" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
}

#pragma mark - Getter

- (MMSearchEngine *)searchEngine {
    if (!_searchEngine) {
        _searchEngine = [MMSearchEngine sharedManager];
        _searchEngine.delegate = self;
    }
    return _searchEngine;
}

@end
