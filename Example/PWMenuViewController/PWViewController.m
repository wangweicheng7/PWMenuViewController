//
//  PWViewController.m
//  PWMenuViewController
//
//  Created by Paul Wang on 04/29/2016.
//  Copyright (c) 2016 Paul Wang. All rights reserved.
//

#import "PWViewController.h"

@interface PWViewController ()


@property (nonatomic, strong) UIView    *testView;
@property (nonatomic, strong) UIView    *testView1;
@property (nonatomic, strong) UIView    *testView2;
@property (nonatomic, strong) UIView    *testView3;

@end

@implementation PWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self.menuTitles addObject:@"夏天来了"];
    [self.menuTitles addObject:@"春天去了"];
    [self.menuTitles addObject:@"秋天还远"];
    [self.menuTitles addObject:@"冬天很冷"];
    
    [self.bottomViews addObject:self.testView];
    [self.bottomViews addObject:self.testView1];
    [self.bottomViews addObject:self.testView2];
    [self.bottomViews addObject:self.testView3];
    
    [self loadSubViews];
    
}

- (UIView *)testView {
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:self.view.bounds];
        _testView.backgroundColor = [UIColor redColor];
    }
    return _testView;
}

- (UIView *)testView1 {
    if (!_testView1) {
        _testView1 = [[UIView alloc] initWithFrame:self.view.bounds];
        _testView1.backgroundColor = [UIColor blueColor];
    }
    return _testView1;
}

- (UIView *)testView2 {
    if (!_testView2) {
        _testView2 = [[UIView alloc] initWithFrame:self.view.bounds];
        _testView2.backgroundColor = [UIColor redColor];
    }
    return _testView;
}

- (UIView *)testView3 {
    if (!_testView3) {
        _testView3 = [[UIView alloc] initWithFrame:self.view.bounds];
        _testView3.backgroundColor = [UIColor grayColor];
    }
    return _testView;
}


@end
