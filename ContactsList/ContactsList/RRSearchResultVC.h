//
//  RRSearchResultVC.h
//  ContactsList
//
//  Created by Rochester on 2/12/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRSearchResultVC : UIViewController
/******模型数组******/
@property (nonatomic,strong) NSArray *dataSource;
/******tableView******/
@property (nonatomic,strong) UITableView *tableView;
@end
