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
@property (nonatomic, assign) CGFloat   titleSpace;

@property (nonatomic, strong) NSMutableArray *bottomViews;
@property (nonatomic, strong) NSMutableArray *menuTitles;
@property (nonatomic, copy) NSString         *currentPage;
@property (nonatomic, strong) UIImageView    *lineIv;
@property (nonatomic, assign) CGSize         buttonSize;
@property (nonatomic, assign) CGSize         lineSize;
@property (nonatomic, strong) UIScrollView    *menuScrollView;
@property (nonatomic, strong) UIScrollView    *bottomScrollView;
@property float ControllerHeight;

- (void)turnToPage:(NSInteger)page;

- (instancetype)init;

- (void)reloadSubViews;

@end