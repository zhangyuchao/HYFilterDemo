//
//  HYUtility.m
//  HYCashier
//
//  Created by Jiangrx on 11/11/15.
//  Copyright © 2015 HuiYuan.NET. All rights reserved.
//

#import "HYUtility.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation HYUtility

#pragma mark - 整形判断
+(BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 浮点形判断
+(BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为空
+(BOOL)isNullOrEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    }
    else if ([str isEqual:[NSNull null]]){
        
        return YES;
    }
    else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
}
#pragma mark 获取时间戳
+(NSString *)getTimeStamp{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}
#pragma mark  - 获取当前日期
+ (NSString *)getNowDate
{
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr=[formatter stringFromDate:date];
    return dateStr;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIImage * )getQRimageWithStr:(NSString *)str withSize:(CGFloat) size{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = str;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *image = [filter outputImage];
    //5.将CIImage转换成UIImage，并放大显示
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - 获取APPICON
+(UIImage *)getAPPIcomImg{
    NSString *imageName = [[[[NSBundle mainBundle] infoDictionary]valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return  [UIImage imageNamed:imageName];
}


#pragma mark - 获取APPICON
+(UIImage *)getLaunchImage{
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString * viewOrientation =@"Portrait";//横屏请设置成 @"Landscape"
    NSString * launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for(NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    if (launchImage != nil) {
        return [UIImage imageNamed:launchImage];
    }else{
        return nil;
    }
}
#pragma mark - 显示提示文字
+(void)showHintWithMsg:(NSString *)msg{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 50)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showImage:nil status:msg];
    [SVProgressHUD dismissWithDelay:2];
    
}
+(void)showLoadingWith:(NSString *)msg{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showWithStatus:msg];
}

+(void)dismissLoadingView{
    [SVProgressHUD dismiss];
}
#pragma mark - 本地沙河路径
+(NSString *)documentPath:(NSString *)fillName{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *finalPath = [docPath stringByAppendingPathComponent:fillName];
    //创建目录
    [fileManager createDirectoryAtPath:[finalPath stringByDeletingLastPathComponent]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];//stringByDeletingLastPathComponent是关键
    return finalPath;
}
#pragma mark string——>obj
+(id)objectFromJSONString:(NSString *)jsonString
{
    
    if (![jsonString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if(!jsonString || jsonString.length <= 0){
        return nil;
    }
    NSError * error = nil;
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    return dic;
}

+(NSString *)jsonStringFromObject:(id)object
{
    if([NSJSONSerialization isValidJSONObject:object]){
        
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
    }
    else {
        NSLog(@"\n %s--- 不是合法的JSONObject\n",__FUNCTION__);
    }
    return nil;
}


+(__kindof UIViewController *)vcFormStoryBoard:(NSString *)storyBoard vcId:(NSString *)vcId{
    UIStoryboard *productStoryboard = [UIStoryboard storyboardWithName:storyBoard bundle:nil];
    return [productStoryboard instantiateViewControllerWithIdentifier:vcId];
}


+(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText withFont:(CGFloat)font withRange:(CGFloat)range1 withRangeNext:(CGFloat)range2{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    [attrString addAttributes:@{
                           NSFontAttributeName:[UIFont boldSystemFontOfSize:font]//字体大小
                           }
                   range:NSMakeRange(range1, range2)];//修改range
    return attrString;
}

//语音播报
+(void)play:(NSString *)textString{
    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:textString];  //需要转换的文本
    utterance.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0){
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    }else{
        utterance.rate = 0.1f;
    }
    utterance.pitchMultiplier = 1.0f;
    [av speakUtterance:utterance];
}

@end

