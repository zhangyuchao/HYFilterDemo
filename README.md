# HYFilterDemo

## 示例图片
![first.png](https://github.com/zhangyuchao/HYFilterDemo/blob/master/Images/first.png)
![second.png]https://github.com/zhangyuchao/HYFilterDemo/blob/master/Images/second.png)
![third.png](https://github.com/zhangyuchao/HYFilterDemo/blob/master/Images/third.png)

## 集成过程
filterView = [[HYFilterView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 48) titleArray:@[
                                                                                                                    @"所有门店",
                                                                                                                    @"交易时间",
                                                                                                                    @"支付类型",
                                                                                                                    @"支付状态"]];
    [self.view addSubview:filterView];
    filterView.delegate = self;

注意实现代理方法
