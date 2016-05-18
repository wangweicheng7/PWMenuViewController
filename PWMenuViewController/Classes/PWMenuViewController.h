//
//  PWMenuViewController.h
//  kidsPlay
//
//  Created by Paul Wang on 16/4/25.
//  Copyright © 2016年 Paul Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWMenuViewController : UIViewController

//两个数组元素个数要相同
@property (nonatomic, assign) CGFloat           titleSpace;

@property (nonatomic, strong) NSMutableArray    *bottomViews;
@property (nonatomic, strong) NSMutableArray    *menuTitles;
@property (nonatomic, strong) UIImageView       *flagImageView;
@property (nonatomic, strong) UIScrollView      *menuScrollView;
@property (nonatomic, strong) UIScrollView      *bottomScrollView;
@property (nonatomic, strong) UIColor           *tintColor;

@property (nonatomic, assign, setter=setCurrentPage:) NSInteger         currentPage;

- (instancetype)init;

/**
 *  @author Paul Wang, 16-04-29 09:04:36
 *
 *  @brief 加载子视图
 */
- (void)loadSubViews;
/**
 *  @author Paul Wang, 16-04-29 09:04:45
 *
 *  @brief 子类必须实现，当前视图的索引
 *
 *  @param index 当前视图的索引
 */
- (void)viewDidScrollToIndex:(NSUInteger)index;
/**
 *  @author Paul Wang, 16-05-06 08:05:38
 *
 *  @brief 显示第几页
 *
 *  @param index 从0开始
 */
- (void)showViewAtIndex:(NSInteger)index;
/**
 *  @author Paul Wang, 16-04-29 10:04:15
 *
 *  @brief 视图滚动代理方法，如果子类要实现这些代理方法，请继承
 *
 *  @param scrollView 滚动视图
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
/**
 *  @author Paul Wang, 16-05-09 17:05:46
 *
 *  @brief 设置菜单标题
 *
 *  @param title 菜单标题
 *  @param index 索引
 */
- (void)setMenuTitle:(NSString *)title atIndex:(NSInteger)index;

@end
