//
//  SelectDateView.h
//  test
//
//  Created by 改车吧 on 16/12/2.
//  Copyright © 2016年 jianye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDateView : UIView
/**
 *  数据数组
 */
@property(nonatomic, strong) NSArray * dataArray;
/**
 *  当前选择的索引 默认0
 */
@property (nonatomic, assign) NSUInteger selectIndex;
/**
 *  回传选中
 */
@property (nonatomic, copy) void(^selectViewBlock)(NSInteger number);

@end
