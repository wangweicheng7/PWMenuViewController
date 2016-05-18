//
//  PWMenuViewController.m
//  kidsPlay
//
//  Created by Paul Wang on 16/4/25.
//  Copyright © 2016年 Paul Wang. All rights reserved.
//

#define kStatusBar   20
#define kTablebar    49
#define kTopScHeight 43
#define kBottomScHeight [UIScreen mainScreen].bounds.size.height - kTopScHeight - kStatusBar - kTablebar

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue)                             [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR_MAKE(r,g,b,a)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//#define COLOR_TEXT_NOR      COLOR_MAKE(255, 110, 17, 1)
//#define COLOR_TEXT_GRAY     COLOR_MAKE(149, 149, 149,1)

#import "PWMenuViewController.h"
#import <CoreText/CoreText.h>


static void * MenuScrollFrameContext = &MenuScrollFrameContext;


@interface PWMenuViewController ()<UIScrollViewDelegate> {
    float           _bottomLastOffsetX; // 底部滚动视图最后一次的横向偏移量
}

@property (nonatomic, strong) NSMutableArray    *centerArr;
@property (nonatomic, strong) NSMutableArray    *titleLabelArray;
//@property (nonatomic, strong) 

@end

@implementation PWMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.menuScrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:MenuScrollFrameContext];
        _currentPage = 0;
    }
    return self;
}

- (void)dealloc {
    [self.menuScrollView removeObserver:self forKeyPath:@"frame"];
}

- (void)loadSubViews {
    
    float labelX = 0.0f;
    for (NSString *title in self.menuTitles) {
        //        CGSize size = [title boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, ScreenWidth/self.menuTitles.count, 43)];
        l.attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:self.tintColor}];
        [self.menuScrollView addSubview:l];
        labelX += l.frame.size.width;
        l.tag = 2000 + [self.menuTitles indexOfObject:title];
        l.textAlignment = NSTextAlignmentCenter;
        NSNumber *num = [NSNumber numberWithFloat:l.center.x];
        [self.centerArr addObject:num];
        [self.titleLabelArray addObject:l];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClicked:)];
        [l addGestureRecognizer:tap];
        l.userInteractionEnabled = YES;
    }
    
    for (id obj in self.bottomViews) {
        if (!obj || ![obj isKindOfClass:[UIView class]]) return;
        UIView *v = obj;
        v.frame = CGRectMake(ScreenWidth * [self.bottomViews indexOfObject:obj] , 0, ScreenWidth, kBottomScHeight);
        [self.bottomScrollView addSubview:v];
    }
    
    self.menuScrollView.contentSize = CGSizeMake(labelX, kTopScHeight);
    NSNumber *num = [_centerArr firstObject];
    
    self.flagImageView.frame = CGRectMake(0, 43, 100.0f, 1);
    self.flagImageView.center = CGPointMake(num.floatValue, 43.5);
    [self.menuScrollView addSubview:self.flagImageView];
    
    
    [self.view addSubview:self.bottomScrollView];
    [self.view addSubview:self.menuScrollView];
    
}

#pragma mark event

- (void)showViewAtIndex:(NSInteger)index {
    _currentPage = index;
}

- (void)setMenuTitle:(NSString *)title atIndex:(NSInteger)index {
    UILabel *l = [self.titleLabelArray objectAtIndex:index];
    l.text = title;
}

- (void)menuItemClicked:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag - 2000;
    [self.bottomScrollView setContentOffset:CGPointMake(index * ScreenWidth, 0) animated:YES];
    
    [self viewDidScrollToIndex:index];
}

#warning 子类需要实现这个方法，检测底部视图当前的索引
- (void)viewDidScrollToIndex:(NSUInteger)index {}

- (void)menuTitleStyleFormat:(float)offset {
    // 获取高亮颜色的 rgba 色值
    const CGFloat *tint_rgb = CGColorGetComponents(self.tintColor.CGColor);
    
    for (int i = 0; i < self.centerArr.count; i ++) {
        float center_x = [self.centerArr[i] floatValue];
        if (offset <= center_x && i == 0) {
            for (UILabel *l in self.titleLabelArray) {
                if (![l isEqual:self.titleLabelArray[0]]) {
                    l.textColor = [UIColor blackColor];
                }else{
                    float scale = offset/center_x;
                    
                    l.textColor = [UIColor colorWithRed: (scale * tint_rgb[0]) green:(scale * tint_rgb[1]) blue:(scale * tint_rgb[2]) alpha:1];
                    l.font = [UIFont systemFontOfSize:16+2*scale];
                }
            }
            return;
        }else if (offset > center_x && i == self.centerArr.count-1){
            for (UILabel *l in self.titleLabelArray) {
                if (![l isEqual:self.titleLabelArray[self.centerArr.count-1]]) {
                    l.textColor = [UIColor blackColor];
                }else{
                    float scale = offset/(ScreenWidth- center_x);
                    
                    l.textColor = [UIColor colorWithRed: (scale * tint_rgb[0]) green:(scale * tint_rgb[1]) blue:(scale * tint_rgb[2]) alpha:1];
                    l.font = [UIFont systemFontOfSize:16+2*scale];
                }
            }
            return;
        }else{
            float center_x2 = [self.centerArr[i+1] floatValue];
            
            // 找到游标所在的区间
            if (offset <= center_x2 && offset > center_x) {
                for (UILabel *l in self.titleLabelArray) {
                    float scale = (offset-center_x)/(center_x2-center_x);
                    if ([l isEqual:self.titleLabelArray[i]]) {
                        // 前一个label
                        scale = 1-scale;
                    }else if ([l isEqual:self.titleLabelArray[i+1]]) {
                        //
                    }else{
                        scale = 0;
                    }
                    l.textColor = [UIColor colorWithRed:scale * tint_rgb[0]  green:scale * tint_rgb[1] blue:scale * tint_rgb[2] alpha:1];
                    l.font = [UIFont systemFontOfSize:16+2*scale];
                }
                return;
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.menuScrollView) {
        return;
    }
    if (scrollView == self.bottomScrollView) {
        float needChange = 0;
        int a =0;
        for (int i =0;i<self.centerArr.count;i++) {
            NSNumber *num = self.centerArr[i];
            if (num.floatValue >= self.flagImageView.center.x) {
                if (i-1>=0) {
                    needChange = [self.centerArr[i] floatValue] - [self.centerArr[i-1] floatValue];
                    a = i;
                    break;
                }
            }
        }
        
        float offset = 0;
        offset = needChange/ScreenWidth *(scrollView.contentOffset.x - (a -1) *ScreenWidth);
        if (a != 0) {
            self.flagImageView.center = CGPointMake([self.centerArr[a -1] floatValue] +  offset, 43.5);
        }
        self.flagImageView.bounds = CGRectMake(0, 0, 100, 1);
        [self menuTitleStyleFormat:self.flagImageView.center.x];
        _bottomLastOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self viewDidScrollToIndex:scrollView.contentOffset.x/ScreenWidth];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 如果 menuscroll 的frame发生变化，bottomscroll也要跟着移动
    if (context == MenuScrollFrameContext) {
        CGRect frame = self.bottomScrollView.frame;
        frame.origin.y = CGRectGetMaxY(self.menuScrollView.frame);
        frame.size.height = self.view.frame.size.height - CGRectGetMaxY(self.menuScrollView.frame);
        self.bottomScrollView.frame = frame;
    }
}

#pragma mark - getters
- (UIScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
        _menuScrollView.delegate = self;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, _menuScrollView.frame.size.height-1.0f, _menuScrollView.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = UIColorFromRGB(0xe0e0e0).CGColor;
        [_menuScrollView.layer addSublayer:bottomBorder];
        
    }
    return _menuScrollView;
}

- (UIScrollView *)bottomScrollView {
    if (!_bottomScrollView) {
        _bottomScrollView = nil;
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScHeight, ScreenWidth, kBottomScHeight)];
        _bottomScrollView.delegate = self;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.clipsToBounds = YES;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.contentSize = CGSizeMake(ScreenWidth * self.bottomViews.count, 0);
        _menuScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bottomScrollView;
}

- (UIImageView *)flagImageView {
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
        _flagImageView.backgroundColor = self.tintColor;
        _flagImageView.contentMode = UIViewContentModeCenter;
        
    }
    return _flagImageView;
}

- (NSMutableArray *)menuTitles {
    if (!_menuTitles) {
        _menuTitles = [NSMutableArray array];
    }
    return _menuTitles;
}

- (NSMutableArray *)bottomViews {
    if (!_bottomViews) {
        _bottomViews = [NSMutableArray array];
    }
    return _bottomViews;
}

- (NSMutableArray *)centerArr {
    if (!_centerArr) {
        _centerArr = [NSMutableArray array];
    }
    return _centerArr;
}

- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (UIColor *)tintColor {
    if (!_tintColor) {
        _tintColor = [UIColor colorWithRed:1 green:110/255.0 blue:17/255.0 alpha:1];
    }
    return _tintColor;
}

@end
