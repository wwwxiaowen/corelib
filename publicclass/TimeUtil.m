//
//  TimeUtil.m
//  wq
//
//  Created by berwin on 13-7-20.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

+(NSDateFormatter *)getDateFromatter{
    static dispatch_once_t pred = 0;
    static NSDateFormatter *formatter = nil;
    dispatch_once(&pred,
                  ^{
                      formatter = [[NSDateFormatter alloc] init];
                      [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
                  });
    return formatter;
}

+(NSDateFormatter *)getDateFromatter1{
    static dispatch_once_t pred1 = 0;
    static NSDateFormatter *formatter1 = nil;
    dispatch_once(&pred1,
                  ^{
                      formatter1 = [[NSDateFormatter alloc] init];
                      [formatter1 setDateFormat:@"yyyy年MM月dd日"];
                  });
    return formatter1;
}

+(NSDateFormatter *)getDateFromatter2{
    static dispatch_once_t pred2 = 0;
    static NSDateFormatter *formatter2 = nil;
    dispatch_once(&pred2,
                  ^{
                      formatter2 = [[NSDateFormatter alloc] init];
                      [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                  });
    return formatter2;
}
//返回距 1970年到现在的秒数
+(NSString *) getSecondsFrom1970{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

//返回1970年到当前时间的的毫秒数
+(NSString *) getMilliSecondsFrom1970{
   return  [NSString stringWithFormat:@"%llu",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
}

//返回1970年到XX时间的的毫秒数
+(NSString *) getMilliSecondsFrom1970ToDate:(NSDate *)date{
    return  [NSString stringWithFormat:@"%llu",(long long)([[NSDate date] timeIntervalSince1970]*1000)];
}

//毫秒转换成日期时间
+(NSString *) longTimeChangeToDate:(NSString *)longTime{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[longTime doubleValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}
 
+ (NSString*)getTimeStr:(long long)time style:(NSInteger)style
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string = [NSString stringWithFormat:@"%04d%@%02d%@%02d%@ %02d:%02d",[component year],style==0?@"-":@"年",[component month],style==0?@"-":@"月",[component day],style==0?@"":@"日",[component hour],[component minute]];
    return string;
}

+ (NSString*)getTimeStrShort:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%04d-%02d-%02d",[component year],[component month],[component day]];
    return string;
}

+ (NSString*)getMDStr:(long long)time
{ 
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%d月%d日",[component month],[component day]];
    return string;
}

+(NSDateComponents*) getComponent:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    return component;
}


+(NSString *) getTimeStrStyleBy:(NSString *) timeText
{
    NSString *handleTime = nil;
    if(!timeText)
        return nil;
    if(timeText.length < 10){
        return nil;
    }else if(timeText.length == 10){
        handleTime = timeText;
    }else if(timeText.length == 13){
        handleTime = [timeText substringToIndex:10];
    }
    
    NSTimeInterval late = [handleTime doubleValue];
    NSString *ddd = [[TimeUtil getDateFromatter2] stringFromDate:[NSDate dateWithTimeIntervalSince1970:late]];
    
    NSTimeInterval now =[[NSDate date] timeIntervalSince1970];
    NSString *currentStr = [[TimeUtil getDateFromatter2] stringFromDate:[NSDate date]];
    NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    NSDate *todayDate= [[TimeUtil getDateFromatter2] dateFromString:todayStr];
    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    NSString *timeString = @"";
    NSTimeInterval cha = now-late;
    if (cha<120) {
        timeString = @"1分钟前";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%d分钟前",(int)cha/60];
    }else if (cha/3600>1&&cha/86400<1) {
        if (late > todaySecond) {
            timeString = [NSString stringWithFormat:@"今天 %@",[ddd substringWithRange:NSMakeRange(11,5)]];
        }else{
            timeString = [NSString stringWithFormat:@"昨天 %@",[ddd substringWithRange:NSMakeRange(11,5)]];
        }
    }else if (cha/86400>1) {
        timeString = [ddd substringWithRange:NSMakeRange(5,11)];
    }
    return timeString;
}


+(NSString*) getTimeStrStyle:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar =[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];

    int year = [component year];
    int month = [component month];
    int day=[component day];
    
    int hour=[component hour];
    int minute=[component minute];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=[component year];
    
    NSString*string=nil;
    
    long long now =[today timeIntervalSince1970];
    
    long  distance = (long)(now - time);
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%ld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%ld小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%ld天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%02d-%02d %d:%02d",month,day,hour,minute];
    else
        string=[NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    
    return string;
}

+(NSString*) getTimeStrStyle1:(long long)time{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year=[component year];
    int month=[component month];
    int day=[component day];
    int hour=[component hour];
    int minute=[component minute];
    int week=[component week];
    int weekday=[component weekday];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=[component year];
    int t_month=[component month];
    int t_day=[component day];
    int t_week=[component week];
    
    NSString*string=nil;
    if(year==t_year&&month==t_month&&day==t_day)
    {
        if(hour<6&&hour>=0)
            string=[NSString stringWithFormat:@"凌晨 %d:%02d",hour,minute];
        else if(hour>=6&&hour<12)
            string=[NSString stringWithFormat:@"上午 %d:%02d",hour,minute];
        else if(hour>=12&&hour<18)
            string=[NSString stringWithFormat:@"下午 %d:%02d",hour,minute];
        else
            string=[NSString stringWithFormat:@"晚上 %d:%02d",hour,minute];
    }
    else if(year==t_year&&week==t_week)
    {
        NSString * daystr=nil;
        switch (weekday) {
            case 1:
                daystr = @"日";
                break;
            case 2:
                daystr = @"一";
                break;
            case 3:
                daystr = @"二";
                break;
            case 4:
                daystr = @"三";
                break;
            case 5:
                daystr = @"四";
                break;
            case 6:
                daystr = @"五";
                break;
            case 7:
                daystr = @"六";
                break;
            default:
                break;
        }
        string=[NSString stringWithFormat:@"周%@ %d:%02d",daystr,hour,minute];
    }
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    return string;
}

+(int)dayCountForMonth:(int)month andYear:(int)year{
    if (month==1||month==3||month==5||month==7||month==8||month==10||month==12) {
        return 31;
    }else if(month==4||month==6||month==9||month==11){
        return 30;
    }else if([self isLeapYear:year]){
        return 29;
    }else{
        return 28;
    }
}
+(BOOL)isLeapYear:(int)year{
    if (year%400==0) {
        return YES;
    }else{
        if (year%4==0&&year%100!=0) {
            return YES;
        }else{
            return NO;
        }
    }
}

@end
