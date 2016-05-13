//
//  ViewController.m
//  TwiterDemo
//
//  Created by Mia on 5/11/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "ViewController.h"
#import "MMSearchEngine.h"

#import "TwitterResult.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, MMSearchEngineDelegate>

@property (nonatomic, strong) MMSearchEngine *searchEngine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    TwitterResult *result = self.searchEngine.searchResults[indexPath.row];
    cell.textLabel.text = result.text;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:searchBar.text forKey:@"searchText"];
    [self.searchEngine startTwitterSearchWithSearchText:searchBar.text];
    [self.view endEditing:YES];
}



#pragma mark - MMSearchEngineDelegate

- (void)searchText:(NSString *)searchText twitterSearchDidSucceed:(NSArray *)searchResults {
    [self.tableView reloadData];
}

- (void)searchText:(NSString *)searchText twitterSearchDidFailed:(NSInteger *)errorCode {
    
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
