//
//  RRContacts.h
//  ContactsList
//
//  Created by Rochester on 2/12/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RRContacts : NSObject
/******名字******/
@property (nonatomic,strong) NSString *name;
/******头像******/
@property (nonatomic,strong) UIImage *image;


+ (NSArray<RRContacts *> *)searchText:(NSString *)searchText inDataArray:(NSArray <RRContacts *>*)dataArray;

@end
