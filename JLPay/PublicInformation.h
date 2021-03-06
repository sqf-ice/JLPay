//
//  PublicInformation.h
//  PosN38Universal
//
//  Created by work on 14-8-8.
//  Copyright (c) 2014年 newPosTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PublicInformation : NSObject

//bbpos已连接
+(BOOL)bbPosHaveConnect;

+(NSString *)returnBBposKeyStr;

+(int)returnSelectIndex;

//当前带星卡号
+(NSString *)getXingCard;

//更新主密钥
+(NSString *)getMainSecret;

//原交易流水号,消费交易的流水号
+(NSString *)returnLiushuiHao;

//消费成功的搜索参考号
+(NSString *)returnConsumerSort;

//消费成功的金额,方便撤销支付
+(NSString *)returnConsumerMoney;

//签到批次号
+(NSString *)returnSignSort;

//二磁道数据
+(NSString *)returnTwoTrack;
//银行卡号
+(NSString *)returnposCard;

//刷卡金额
+(NSString *)returnMoney;

//流水号,每次交易，递增,bcd,6(000008)
+(NSString *)exchangeNumber;

//初始化终端成功，可以签到
//+(BOOL)initTerminalSuccess;

//卡号转换
+(NSString *)returnCard:(NSString *)card;

//保存终端号，商户号，商户名称
+(NSString *)returnTerminal;
+(NSString *)returnBusiness;
+(NSString *)returnBusinessName;


//签到保存mackey，pinkey
+(NSString *)signinPin;
+(NSString *)signinMac;

+(NSString *)settingIp;
+(int)settingPort;

//十六进制转化二进制
+(NSString *)getBinaryByhex:(NSString *)hex;

//二进制转十六进制
+(NSString *)binaryToHexString:(NSString *)str;

//二进制取反
+(NSString *)binaryToAgain:(NSString *)str;

//十六进制转十进制
+(int)sistenToTen:(NSString*)tmpid;

//十进制转16进制
+(NSString *)ToBHex:(int)tmpid;

//16进制转字符串（ascii）
+(NSString *)stringFromHexString:(NSString *)hexString;

//data转nsstring
+ (NSString*)stringWithHexBytes2:(NSData *)theData;


//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+ (UIImage *) createImageWithColor: (UIColor *) color;


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//更新十六进制字符串转bytes
+(NSData *) NewhexStrToNSData:(NSString *)hexStr;

+(NSString *)formatDate;

+(NSString *)formatCompareDate;

+(BOOL)isCurrentToday:(NSString *)dateStr;


//判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+(NSString *) returnUploadTime:(NSString  *)timeStr;

+(NSString *) NEWreturnUploadTime:(NSString  *)timeStr;

@end
