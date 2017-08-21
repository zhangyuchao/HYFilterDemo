//
//  ViewController.m
//  HYFilterDemo
//
//  Created by  huiyuan on 2017/8/21.
//  Copyright © 2017年 张宇超. All rights reserved.
//

#import "ViewController.h"
#import "HYFilterView.h"
#import "HYUtility.h"
@interface ViewController ()<HYFilterViewDelegate>
{
    HYFilterView *filterView;
    UIButton * backgroundView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [HYUtility colorWithHexString:@"#EBEBF1"];
    filterView = [[HYFilterView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 48) titleArray:@[
                                                                                                                    @"所有门店",
                                                                                                                    @"交易时间",
                                                                                                                    @"支付类型",
                                                                                                                    @"支付状态"]];
    [self.view addSubview:filterView];
    filterView.delegate = self;
}

#pragma mark - filterViewDelegate
-(NSArray *)filterViewDataSourceArrayAtIndex:(NSInteger)index{
    if (index == 0) {
        return @[@"第一",@"第二",@"第三",@"第四"];
    }
    if (index == 1) {
        return @[@"今天",@"前一天",@"三天内",@"七天内"];
    }
    if (index == 2) {
        return @[@"全部",@"微信支付",@"支付宝",@"银联刷卡"];
    }
    if (index == 3) {
        return @[@"全部",@"已完成",@"退款中",@"已关闭"];
    }
    return nil;
}
-(void)filterViewDidHidenMenu{
    [backgroundView removeFromSuperview];
}
-(void)filterViewDidShowMenuAtIndex:(NSInteger)index{
    [self addBackgroundView];
    NSLog(@"显示了弟%ld个列表",index);
}
-(void)addBackgroundView{
    backgroundView = [[UIButton alloc]initWithFrame:self.view.frame];
    [self.view addSubview:backgroundView];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.4;
    [backgroundView addTarget:self action:@selector(hintFilterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:filterView];
}
-(void)hintFilterView{
    [filterView hidenMenu];
    [backgroundView removeFromSuperview];
}
-(void)filterViewDidSelectAtIndex:(NSInteger)index atRow:(NSInteger)row{
    NSLog(@"选择了%ld %ld",(long)index,(long)row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
