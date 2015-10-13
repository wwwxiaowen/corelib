//
//  TimeUtil.h
//  wq
//
//  Created by berwin on 13-7-20.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

//yyyy年MM月dd日 HH:mm:ss
+(NSDateFormatter *)getDateFromatter;

//yyyy:MM:dd HH:mm:ss
+(NSDateFormatter *)getDateFromatter1;

//yyyy-MM-dd HH:mm:ss
+(NSDateFormatter *)getDateFromatter2;


//返回距 1970年到现在的秒数
+(NSString *) getSecondsFrom1970;

//返回1970年到当前时间的的毫秒数
+(NSString *) getMilliSecondsFrom1970;

//返回1970年到XX时间的的毫秒数
+(NSString *) getMilliSecondsFrom1970ToDate:(NSDate *)date;

//毫秒转换成日期时间
+(NSString *) longTimeChangeToDate:(NSString *)longTime;


//计算流逝的时间 参数为一个标准格式的时间字符串
/*
 0分钟00秒-0分钟59秒   1分钟前；
 1分钟00秒-1分钟59秒   1分钟前；
 ⋯⋯                  ⋯⋯
 58分钟00秒-58分钟59秒 59分钟前；
 59分00秒-23小时59分钟59秒 今天 HH:MM
 24小时-48小时内           昨天 HH:MM
 之后时间                  MM-DD HH:MM
 */
+(NSString *) getTimeStrStyleBy:(NSString *) timeText;


//style 0 yyyy-MM-dd HH:mm
//style 1 yyyy年MM月dd日 HH:mm
+ (NSString*)getTimeStr:(long long)time style:(NSInteger)style;

//yyyy-MM-dd
+ (NSString*)getTimeStrShort:(long long)time;

//xx月xx日
+ (NSString*)getMDStr:(long long)time;

//时间组建
+(NSDateComponents*)getComponent:(long long)time;

//计算流逝的时间 参数为一个标准格式的时间 
/*
 0分钟00秒-0分钟59秒          刚刚；
 1分钟00秒-1分钟59秒          1分钟前；
 ⋯⋯                         ⋯⋯
 58分钟00秒-58分钟59秒        59分钟前；
 1小时0分0秒-23小时59分钟59秒  XX小时前
 24小时-24*7小时内            XX天前
 一年之内                     MM-DD HH:MM
 一年之外                     yyyy-MM-DD
 */
+(NSString*) getTimeStrStyle:(long long)time;


//计算流逝的时间 参数为一个标准格式的时间
/*
 0-6小时             凌晨 xx:xx
 6-12小时            上午 xx:xx
 12-18小时           下午 xx:xx
 18-24小时           晚上 xx:xx
 24-24*7小时         周x xx:xx
 一年以内             xx月xx日
 一年以外             xx年xx月xx日
 */
+(NSString*) getTimeStrStyle1:(long long)time;


//返回 year年的month月 的天数
+(int)dayCountForMonth:(int)month andYear:(int)year;

//是否闰年
+(BOOL)isLeapYear:(int)year;

@end
