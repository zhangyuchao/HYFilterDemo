//
//  HYFilterView.m
//  HYFilterDemo

#import "HYFilterView.h"
#import "HYUtility.h"

@interface HYFilterView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGRect defaultFrame;
    NSInteger selectIndex;
    NSArray * dataSourceArray;
}
@property (nonatomic ,strong) UITableView * tableView;


@end


@implementation HYFilterView



-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray * )array{
    if (self = [super initWithFrame:frame]) {
        defaultFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i<array.count; i++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i * (self.bounds.size.width/array.count),
                                                                       0,
                                                                       self.bounds.size.width/array.count,
                                                                       self.bounds.size.height)];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            //未选中状态
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"darkArrow"] forState:UIControlStateNormal];
            //选中状态
            [btn setTitleColor:[HYUtility colorWithHexString:@"#00C2FF"] forState:UIControlStateSelected];//HEXCOLOR(@"#00C2FF")
            [btn setImage:[UIImage imageNamed:@"blueArrow"] forState:UIControlStateSelected];
            NSDictionary *attr=@{NSFontAttributeName:btn.titleLabel.font};
            CGRect rect = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(115, 25) options:NSStringDrawingUsesFontLeading attributes:attr context:nil];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                   rect.size.width,
                                                   0,
                                                   -rect.size.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                   -btn.currentImage.size.width,
                                                   0,
                                                   btn.currentImage.size.width);
            btn.tag = i;
            [btn addTarget:self action:@selector(didSelectTitle:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}
-(void)didSelectTitle:(UIButton *)sender{
    if (sender.isSelected) {
        [self hidenMenu];
        sender.selected = NO;
    }else{
        [self showMenuAtIndex:sender.tag];
        sender.selected = YES;
    }
}
//显示列表
-(void)showMenuAtIndex:(NSInteger)index{
    [self hidenMenu];
    selectIndex = index;
    dataSourceArray = [self.delegate filterViewDataSourceArrayAtIndex:selectIndex];
    CGRect tabeViewFrame = CGRectMake(0,
                                      self.bounds.size.height,
                                      self.bounds.size.width,
                                      dataSourceArray.count*44>=self.bounds.size.width?self.bounds.size.width:dataSourceArray.count*44);
    
    self.frame = CGRectMake(defaultFrame.origin.x,
                            defaultFrame.origin.y,
                            defaultFrame.size.width,
                            defaultFrame.size.height + tabeViewFrame.size.height);
    _tableView = [[UITableView alloc]initWithFrame:tabeViewFrame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidShowMenuAtIndex:)]) {
        [self.delegate filterViewDidShowMenuAtIndex:selectIndex];
    }
}
//隐藏列表
-(void)hidenMenu{
    self.frame = defaultFrame;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_tableView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidHidenMenu)]){
        [self.delegate filterViewDidHidenMenu];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toast"]];
//        [cell.contentView addSubview:imageView];
//        imageView.hidden = YES;
//        imageView.frame = CGRectMake(0, 0, 25, 18);
//        imageView.center = CGPointMake(0, 0 );
    }
    cell.textLabel.text = [dataSourceArray objectAtIndex:indexPath.row];
    cell.separatorInset=UIEdgeInsetsZero;
    cell.layoutMargins=UIEdgeInsetsZero;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hidenMenu];
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewDidSelectAtIndex:atRow:)]) {
        [self.delegate filterViewDidSelectAtIndex:selectIndex atRow:indexPath.row];
    }
    [self changeTitle:[dataSourceArray objectAtIndex:indexPath.row] AtIndex:selectIndex];
}
-(void)changeTitle:(NSString *)title AtIndex:(NSInteger)index{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            if (btn.tag == selectIndex) {
                [btn setTitle:title forState:UIControlStateNormal];
                NSDictionary *attr=@{NSFontAttributeName:btn.titleLabel.font};
                CGRect rect = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(115, 25) options:NSStringDrawingUsesFontLeading attributes:attr context:nil];
                btn.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                       rect.size.width,
                                                       0,
                                                       -rect.size.width);
                btn.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                       -btn.currentImage.size.width,
                                                       0,
                                                       btn.currentImage.size.width);
            }
        }
    }
}

@end
