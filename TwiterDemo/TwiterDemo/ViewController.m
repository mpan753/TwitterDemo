//
//  ViewController.m
//  TwiterDemo
//
//  Created by Mia on 5/11/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#import "ViewController.h"
#import "MMSearchEngine.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MMSearchEngine *searchEngine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchEngine startTwitterSearchWithSearchText:searchBar.text];
    [self.view endEditing:YES];
}

#pragma mark - Getter

- (MMSearchEngine *)searchEngine {
    if (!_searchEngine) {
        _searchEngine = [MMSearchEngine sharedManager];
    }
    return _searchEngine;
}

@end
