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
#define kButtonFont     16
#define kMenuTitleSpace 20

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue)                             [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR_MAKE(r,g,b,a)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define COLOR_TEXT_NOR      COLOR_MAKE(255, 110, 17, 1)
#define COLOR_TEXT_GRAY     COLOR_MAKE(149, 149, 149,1)

#import "PWMenuViewController.h"
#import <CoreText/CoreText.h>

@interface PWMenuViewController ()<UIScrollViewDelegate> {
//    UILabel         *_line;
//    NSMutableArray  *_centerArr;
//    NSMutableArray  *_widthArr;
    float           _bottomLastOffsetX;
//    CGFloat         _lineLastX;     // 下划线上一次的横坐标点
//    NSInteger       _prePage;
//    NSInteger       _finalPage;
//    BOOL            _isBtnClick;
//    UIView          *_moreView;
}

@property (nonatomic, strong) UIImageView   *flagImageView;
@property (nonatomic, strong) NSMutableArray    *centerArr;
@property (nonatomic, strong) NSMutableArray    *titleLabelArray;
//@property (nonatomic, strong) 

@end

@implementation PWMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _bottomViews = [NSMutableArray array];
        _menuTitles = [NSMutableArray array];
        _centerArr = [NSMutableArray array];
        _titleLabelArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if ([super init]) {
        //        _widthArr = [NSMutableArray array];
        //        _line = [[UILabel alloc] init];
        _lineIv = [[UIImageView alloc] init];
        _lineSize = CGSizeMake(12, 4);
//        _prePage = 0;
//        _finalPage = _prePage;
//        _currentPage = [NSString stringWithFormat:@"%ld", (long)_finalPage];
//        _moreView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 10, 0, 10, 44)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bottomViews = [NSMutableArray array];
    _menuTitles = [NSMutableArray array];
    _centerArr = [NSMutableArray array];
    _titleLabelArray = [NSMutableArray array];
}

- (void)reloadSubViews {
    
    
    
    
    float labelX = 0.0f;
    for (NSString *title in self.menuTitles) {
//        CGSize size = [title boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
//        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, size.width + self.titleSpace, self.menuScrollView.frame.size.height - 1)];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, ScreenWidth/self.menuTitles.count, 43)];
        l.attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:COLOR_TEXT_NOR}];
        [self.menuScrollView addSubview:l];
        labelX += l.frame.size.width;
        l.tag = 2000 + [self.menuTitles indexOfObject:title];
        l.textAlignment = NSTextAlignmentCenter;
        NSNumber *num = [NSNumber numberWithFloat:l.center.x];
        [self.centerArr addObject:num];
        [self.titleLabelArray addObject:l];
    }
    
    for (id obj in self.bottomViews) {
        if (!obj || ![obj isKindOfClass:[UIView class]]) return;
        UIView *v = obj;
        v.frame = CGRectMake(ScreenWidth * [self.bottomViews indexOfObject:obj] , 0, v.frame.size.width, v.frame.size.height);
        [self.bottomScrollView addSubview:v];
    }
    
    self.menuScrollView.contentSize = CGSizeMake(labelX, kTopScHeight);
    NSNumber *num = [_centerArr firstObject];
    
    self.flagImageView.frame = CGRectMake(0, 43, 100.0f, 1);
    self.flagImageView.center = CGPointMake(num.floatValue, 43.5);
    //    [_topScroll addSubview:line];
    [self.menuScrollView addSubview:self.flagImageView];

    
    [self.view addSubview:self.bottomScrollView];
    [self.view addSubview:self.menuScrollView];
    
}

#pragma mark - getters
- (UIScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
        _menuScrollView.delegate = self;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        
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
        _bottomScrollView.contentSize = CGSizeMake(ScreenWidth * self.bottomViews.count, 100);
    }
    return _bottomScrollView;
}

- (UIImageView *)flagImageView {
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
        _flagImageView.backgroundColor = COLOR_TEXT_NOR;
        
    }
    return _flagImageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
        [self formatColor:self.flagImageView.center.x];
        _bottomLastOffsetX = scrollView.contentOffset.x;
    }
}

- (void)formatColor:(float)offset {
    for (int i = 0; i < self.centerArr.count; i ++) {
        float center_x = [self.centerArr[i] floatValue];
        
        //
        if (offset <= center_x && i == 0) {
            for (UILabel *l in self.titleLabelArray) {
                if (![l isEqual:self.titleLabelArray[0]]) {
                    l.textColor = COLOR_TEXT_GRAY;
                }else{
                    float scale = offset/center_x;
                    
                    l.textColor = [UIColor colorWithRed: (149+ scale * (255-149))/255 green:(149-scale * (149-110))/255 blue:(149- scale * (149-17))/255 alpha:1];
                    l.font = [UIFont systemFontOfSize:16+2*scale];
                }
            }
            return;
        }else if (offset > center_x && i == self.centerArr.count-1){
            for (UILabel *l in self.titleLabelArray) {
                if (![l isEqual:self.titleLabelArray[self.centerArr.count-1]]) {
                    l.textColor = COLOR_TEXT_GRAY;
                }else{
                    float scale = offset/(ScreenWidth- center_x);
                    
                    l.textColor = [UIColor colorWithRed: (149+ scale * (255-149))/255 green:(149-scale * (149-110))/255 blue:(149- scale * (149-17))/255 alpha:1];
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
                    
                    float r = (149+ scale * (255-149));
                    float g = (149-scale * (149-110));
                    float b = (149- scale * (149-17));
                    
                    l.textColor = [UIColor colorWithRed:r/255  green:g/255 blue:b/255 alpha:1];
                    l.font = [UIFont systemFontOfSize:16+2*scale];
                }
                return;
            }
        }
    }
}

#if 0
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.bottomScrollView) {
        
        if (!decelerate) {
            _prePage = _finalPage;
            _finalPage = (NSInteger)scrollView.contentOffset.x/ScreenWidth;
            _currentPage = [NSString stringWithFormat:@"%ld", (long)_finalPage];
            [self changeTop];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bottomScroll) {
        _prePage = _finalPage;
        _finalPage = (NSInteger)scrollView.contentOffset.x/ScreenWidth;
        _currentPage = [NSString stringWithFormat:@"%ld", (long)_finalPage];
        [self changeTop];
    }
    
}
- (void)changeTop
{
    _isBtnClick = NO;
    float x = [_centerArr[_finalPage] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        if (x>ScreenWidth/2.0&&x<_topScroll.contentSize.width - ScreenWidth/2.0) {
            _topScroll.contentOffset = CGPointMake(x-ScreenWidth/2.0, 0);
        }
        else if (x>=_topScroll.contentSize.width - ScreenWidth/2.0) {
            _topScroll.contentOffset = CGPointMake(_topScroll.contentSize.width - ScreenWidth, 0);
        }
        else{
            _topScroll.contentOffset = CGPointMake(0, 0);
        }
    }];
    
    /**************** <#content#> ******************/
    [self changeButtonTitleColor];
}
- (void)btnClick:(UIButton *)button
{
    _isBtnClick = YES;
    _prePage = _finalPage;
    _finalPage = button.tag - 2000;
    _currentPage = [NSString stringWithFormat:@"%ld", (long)_finalPage];
    [self changeBottom];
    [self changeTop];
    [self changeLineWithBtn:button];
    
}
- (void)changeLineWithBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _lineIv.bounds = CGRectMake(0, 0, _lineSize.width, _lineSize.height);
        _lineIv.center = CGPointMake(btn.center.x, kTopScHeight - _lineSize.height/2.0);
    } completion:^(BOOL finished) {
        
    }];
    [self changeButtonTitleColor];
}
//- (void)changeLine
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _lineIv.frame = CGRectMake([_centerArr[_FinalPage] floatValue] -[_widthArr[_FinalPage] floatValue]/2.0, kTopScHeight - _lineSize.height, _lineSize.width, _lineSize.height);
//    }];
//    [self changeButtonTitleColor];
//}
- (void)changeBottom
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomScroll.contentOffset = CGPointMake(ScreenWidth *_finalPage, 0);
    } completion:^(BOOL finished) {
        
    }];
}

// 改变菜单项
- (void)changeButtonTitleColor
{
    _lineLastX = _lineIv.center.x;
    // 发送翻页通知，将页码作为参数传出
    [self turnToPage:_finalPage];
    
    UIButton *btn = (UIButton *)[_topScroll viewWithTag:_prePage + 2000];
    UIButton *btn2 = (UIButton *)[_topScroll viewWithTag:_finalPage + 2000];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        btn.titleLabel.textColor = COLOR_TEXT_SEL;
        [btn setTitleColor:COLOR_TEXT_SEL forState:UIControlStateNormal];
//        btn.titleLabel.font = KAT_GLOBAL_FONT_CN_SIZE(FONT_SIZE_HOME_MENU_TEXT_NOR);
        btn2.titleLabel.textColor = COLOR_GLOBEL_ORANGE;
        [btn2 setTitleColor:COLOR_GLOBEL_ORANGE forState:UIControlStateNormal];
//        btn2.titleLabel.font = KAT_GLOBAL_FONT_CN_SIZE(FONT_SIZE_HOME_MENU_TEXT_HL);
    }];
}


- (void)turnToPage:(NSInteger)page {
    
}
#endif
@end
