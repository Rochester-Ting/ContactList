//
//  ViewController.m
//  ContactsList
//
//  Created by Rochester on 2/12/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "ViewController.h"
#import "RRContacts.h"
#import "RRSearchResultVC.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>
/******tableView******/
@property (nonatomic,strong) UITableView *tableView;
/******searchBar******/
@property (nonatomic,strong) UISearchBar *seachBar;
/******uisearchController******/
@property (nonatomic,strong) UISearchController *searchController;



/******存放有效索引的数组******/
@property (nonatomic,strong) NSMutableArray *indexs;
/******本地区所有的索引******/
@property (nonatomic,strong) NSArray *allIndexs;
/******数据源方法******/
@property (nonatomic,strong) NSMutableArray *dataSource;
/******所有的用户姓名******/
@property (nonatomic,strong) NSMutableArray *allData;
@end

@implementation ViewController
#pragma mark - allData
- (NSMutableArray *)allData{
    if (!_allData) {
        _allData = [NSMutableArray array];
        for (int i = 0; i < self.dataSource.count; i++) {
            NSArray *temp = self.dataSource[i];
            if (temp.count != 0) {
                for (RRContacts *contact in temp) {
                    [_allData addObject:contact];
                }
            }
        }
    }
    return _allData;
}
#pragma mark - UISearchController
- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:[[RRSearchResultVC alloc] init]];
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.placeholder = @"搜索联系人姓名/首字母缩写";

        
    }
    return _searchController;
}
#pragma mark - tableview的懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
    }
    return _tableView;
}
#pragma mark - searchBar的懒加载
- (UISearchBar *)seachBar{
    if (!_seachBar) {
        _seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _seachBar.delegate = self;
        _seachBar.placeholder = @"请输入想要查询的内容";
//        _seachBar.is
    }
    return _seachBar;
}

#pragma mark - indexs的懒加载
- (NSMutableArray *)indexs{
    if (!_indexs) {
        _indexs = [NSMutableArray array];
    }
    return _indexs;
}
#pragma mark - 数据源的懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"123"];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.seachBar;
    
    // 数组转模型
    NSArray *testArray = @[@"ZeroJ", @"李美建", @"朱耿增", @"田扬", @"曾晶" , @"曾晶" , @"曾晶" , @"曾晶" , @"杨卢青" , @"王森" , @"曾晶",  @"曾好", @"李涵", @"王丹", @"良好", @"124"];
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for (NSString *name in testArray) {
        RRContacts *contact = [[RRContacts alloc] init];
        contact.name = name;
        contact.image = [UIImage imageNamed:@"Snip20161011_5"];
        [contacts addObject:contact];
    }
    
    [self initWithAllData:contacts];
}
#pragma mark - 初始化数据
- (void)initWithAllData:(NSArray *)contacts{
    // 模型name的get方法
    SEL getName = @selector(name);
    // 获取本地区所有的索引
    UILocalizedIndexedCollation *localIndex = [UILocalizedIndexedCollation currentCollation];
    self.allIndexs = localIndex.sectionTitles;
    
    for (int i = 0; i < self.allIndexs.count; i++) {
        [self.dataSource addObject:[NSMutableArray array]];
    }
    // 遍历模型数组
    for (RRContacts *contact in contacts) {
        if (contact == nil) {
            continue;
        }
        // 获取该模型的索引
        NSInteger index = [localIndex sectionForObject:contact collationStringSelector:getName];
        if ([contact.name hasPrefix:@"曾"]) {
            index = [self.allIndexs indexOfObject:@"Z"];
        }
        
        
        [self.dataSource[index] addObject:contact];
    }
//    NSLog(@"---%@",self.dataSource);
    // 去除内容为空的索引
    for (int i = 0; i < self.dataSource.count; i++) {
        NSArray *temp = self.dataSource[i];
        if (temp.count != 0) {
            [self.indexs addObject:[NSNumber numberWithInt:i]];
        }
        
    }
    
}
#pragma mark - uitableviewDelegate
#pragma mark - 返回组头的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSNumber *number = self.indexs[section];
    return self.allIndexs[number.integerValue];
}
#pragma mark - 返回索引数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.indexs;
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSNumber *number in self.indexs) {
        [indexArr addObject:self.allIndexs[number.integerValue]];
    }
    return indexArr;
}
#pragma mark - 坚挺索引的点击
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"%@---%ld", title, index);
    // 显示正在点击的indexTitle ZJProgressHUD这个小框架是我们已经实现的
//    [ZJProgressHUD showStatus:title andAutoHideAfterTime:0.5];
    return index;
}

#pragma mark - uitableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = [self.indexs[section] integerValue];
    NSArray *temp = self.dataSource[index];
    return temp.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    NSNumber *number = self.indexs[indexPath.section];
    NSArray *temp = self.dataSource[number.integerValue];
    RRContacts *contact = temp[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",contact.name];
    cell.imageView.image = contact.image;
    return cell;
}
#pragma mark - searchBarDelegate
// 点击searchBar
#pragma mark - 当searchBar被点击的时候
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (searchBar == self.seachBar) {
        
        [self presentViewController:self.searchController animated:YES completion:nil];
        return NO;
    }
    return YES;
}
#pragma mark - searchBar文字改变的时候
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar == self.searchController.searchBar) {
        RRSearchResultVC *searchResultVC = (RRSearchResultVC *)self.searchController.searchResultsController;
        searchResultVC.dataSource = [RRContacts searchText:searchText inDataArray:self.allData];
    }
}
// 这个方法在searchController 出现, 消失, 以及searchBar的text改变的时候都会被调用
// 我们只是需要在searchBar的text改变的时候才查询数据, 所以没有使用这个代理方法, 而是使用了searchBar的代理方法来处理
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //    NSLog(@"%@", searchController.searchBar.text);
//        RRSearchResultVC *resultController = (RRSearchResultVC *)searchController.searchResultsController;
//        resultController.dataSource = [RRContacts searchText:searchController.searchBar.text inDataArray:_allData];
//        [resultController.tableView reloadData];

}

// 这个代理方法在searchController消失的时候调用, 这里我们只是移除了searchController, 当然你可以进行其他的操作
- (void)didDismissSearchController:(UISearchController *)searchController {
    // 销毁
    self.searchController = nil;
}

@end
