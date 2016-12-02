//
//  RRSearchResultVC.m
//  ContactsList
//
//  Created by Rochester on 2/12/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRSearchResultVC.h"
#import "RRContacts.h"
@interface RRSearchResultVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RRSearchResultVC
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kk"];
}
- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    NSLog(@"--%@",dataSource);
    [self.tableView reloadData];
}
#pragma mark - delegate
#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kk"];
    RRContacts *contact = self.dataSource[indexPath.row];
    cell.textLabel.text = contact.name;
    return cell;
}

@end
