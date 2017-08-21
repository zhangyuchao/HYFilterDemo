//
//  HYFilterView.h
//  HYFilterDemo

#import <UIKit/UIKit.h>

@protocol HYFilterViewDelegate <NSObject>
-(NSArray *)filterViewDataSourceArrayAtIndex:(NSInteger )index;
-(void)filterViewDidSelectAtIndex:(NSInteger)index atRow:(NSInteger)row;
-(void)filterViewDidShowMenuAtIndex:(NSInteger)index;
-(void)filterViewDidHidenMenu;
@end

@interface HYFilterView : UIView

@property (nonatomic ,weak) id<HYFilterViewDelegate> delegate;


-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)array;
-(void)hidenMenu;


@end
