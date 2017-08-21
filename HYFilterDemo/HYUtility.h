//
//  HYUtility.h
//  HYCashier
//
//  Created by Jiangrx on 11/11/15.
//  Copyright © 2015 HuiYuan.NET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

@interface HYUtility : NSObject


+(BOOL)isNullOrEmpty:(NSString *)str;
+(BOOL)isPureInt:(NSString *)string;
+(BOOL)isPureFloat:(NSString *)string;
#pragma mark 获取时间戳
+(NSString *)getTimeStamp;
#pragma mark  - 获取当前日期
+ (NSString *)getNowDate;
#pragma mark - 十六进制转换成颜色 （@"#FFFFFF"）
+ (UIColor *) colorWithHexString:(NSString *)color;
#pragma mark - string——>obj
+(id)objectFromJSONString:(NSString *)jsonString;
+(NSString *)jsonStringFromObject:(id)object;
#pragma mark - 获取StoryBoard 中的 ViewController
+(__kindof UIViewController *)vcFormStoryBoard:(NSString *)storyBoard vcId:(NSString *)vcId;
#pragma mark - 字符串转换成二维码图片
+(UIImage * )getQRimageWithStr:(NSString *)str withSize:(CGFloat) size;
#pragma mark - 获取APPICON
+(UIImage *)getAPPIcomImg;
#pragma mark - 获取APPLaunch
+(UIImage *)getLaunchImage;
#pragma mark - 显示提示文字
+(void)showHintWithMsg:(NSString *)msg;
#pragma mark - 显示加载框
+(void)showLoadingWith:(NSString *)msg;
#pragma mark - 隐藏加载框
+(void)dismissLoadingView;
#pragma mark - 本地沙河路径
+(NSString *)documentPath:(NSString *)fillName;
#pragma mark - 创建一个返回富文本的方法
+(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText withFont:(CGFloat)font withRange:(CGFloat)range1 withRangeNext:(CGFloat)range2;
#pragma mark - 语音播报
+(void)play:(NSString *)textString;

@end
