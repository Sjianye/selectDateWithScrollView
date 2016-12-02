//
//  SelectDateView.m
//  test
//
//  Created by 改车吧 on 16/12/2.
//  Copyright © 2016年 jianye. All rights reserved.
//

#import "SelectDateView.h"
#define TOPMARGIN 0
//#define ANIMATIONDUARATION 2
//#define CENTERVIEWBORDERWIDTH 1

#define NORMALFONTSIZE 14
#define SELECTFONTSIZE 20


@interface SelectDateView()<UIScrollViewDelegate>
{
    CGFloat _itemWidth;
}
/**内部的scrollView*/
@property (nonatomic,weak) UIScrollView * scrollView;
/**中间的选择框*/
@property (nonatomic,weak) UIView * centerView;
/**按钮的数组*/
@property(nonatomic,strong)NSMutableArray * btnArray;
/**记录被选中的按钮*/
@property (nonatomic,weak) UIButton * selectBtn;


/**
 *  选择框的宽度
 */
@property (nonatomic, assign) CGFloat selectViewWidth;



@end

@implementation SelectDateView


#pragma mark - lazyLoad
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _selectViewWidth = 40;
        
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;

        UIView *centerView = [[UIView alloc]init];
        [self addSubview:centerView];
        centerView.backgroundColor = [UIColor clearColor];
        
        centerView.layer.borderColor = [UIColor orangeColor].CGColor;
        centerView.layer.borderWidth = 2;
        
        self.centerView = centerView;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
    CGFloat btnH = self.scrollView.bounds.size.height;
    _itemWidth = MAX(_selectViewWidth, (self.bounds.size.height - 2 * TOPMARGIN - 2));
    CGFloat leftMargin = self.bounds.size.width * 0.5 - _itemWidth * 0.5;
    for (int i = 0; i < self.btnArray.count; i ++) {
        UIButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(i * _itemWidth + leftMargin, 0, _itemWidth, btnH);
    }
    UIButton *lastBtn = self.btnArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + leftMargin, 0);
    
    CGFloat viewH = self.bounds.size.height - 2 * TOPMARGIN;
    self.centerView.frame = CGRectMake(leftMargin, TOPMARGIN, _itemWidth, viewH);
    self.centerView.layer.cornerRadius = viewH * 0.5;
    
    NSInteger index = _selectIndex < self.btnArray.count?_selectIndex:(self.btnArray.count - 1);
    UIButton *selectButton = [self.btnArray objectAtIndex:index];
    self.selectBtn.selected = NO;
    selectButton.selected = YES;
    self.selectBtn = selectButton;
    [self.scrollView setContentOffset:CGPointMake(index * _itemWidth, 0)];

}
#pragma mark - setting dataArray
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        NSString *titleStr = [NSString stringWithFormat:@"%@月",dataArray[i]];
        [btn setTitle:titleStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:NORMALFONTSIZE];
        
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.btnArray addObject:btn];
    }
}

- (void)clickItem:(UIButton *)btn {
    if (btn.tag == self.selectBtn.tag) {
        return;
    }

     NSInteger index = [self.btnArray indexOfObject:btn];
    //判断移动方向
    BOOL isRight = btn.tag < self.selectBtn.tag;
    CGFloat moveDistance = isRight?(index * _itemWidth - _itemWidth * 0.2):(index * _itemWidth + _itemWidth * 0.2);
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:NORMALFONTSIZE];
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:SELECTFONTSIZE];
    
    //执行动画
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
            [self.scrollView setContentOffset:CGPointMake(moveDistance, 0)];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
            [self.scrollView setContentOffset:CGPointMake(index * _itemWidth, 0)];
        }];
    } completion:nil];


    //通知blick回调
    if (self.selectViewBlock) {
        self.selectViewBlock(index);
    }
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / _itemWidth + 0.5;
    
    if (index >= self.btnArray.count) {
        index = self.btnArray.count -1;
    }
    UIButton *btn = [self.btnArray objectAtIndex:index];
    
    self.selectBtn.selected = NO;
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:NORMALFONTSIZE];
    
    btn.selected = YES;
    self.selectBtn = btn;
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:SELECTFONTSIZE];

}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat targetX = targetContentOffset->x;
    NSUInteger i = targetX / _itemWidth + 0.5;
    *targetContentOffset = CGPointMake(i * _itemWidth, 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / _itemWidth + 0.5;
    
    UIButton *btn = [self.btnArray objectAtIndex:index];
    
    NSString *title = btn.currentTitle;
    NSLog(@"title%@",title);

    //通知blick回调
    if (self.selectViewBlock) {
        self.selectViewBlock(index);
    }

}

- (void)setSelectIndex:(NSUInteger)selectIndex{
    if (self.dataArray.count) {
        if (selectIndex >= self.dataArray.count) {
            _selectIndex = self.dataArray.count -1;
        }
        else{
            _selectIndex = selectIndex;
        }
    }
    else{
        _selectIndex = selectIndex;
    }
}









@end










