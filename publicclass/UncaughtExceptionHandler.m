//
//  UncaughtExceptionHandler.m
//  MYTDoctor
//
//  Created by 温火光 on 15/7/1.
//  Copyright (c) 2015年 dexingrongtong. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    //	    [UIDevice currentDevice].uniqueIdentifier];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}


void MySignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    if(signal==11) {
        //比较坑爹的是 我遇到的一个问题只有iPhone5出现问题 但是我这边测试的没有iPhone5 无法直接log  可能是内存不足 果然 删除几个应用就可以了 所以加了这句
        UIAlertView * tip2 = [[UIAlertView alloc]initWithTitle:@"可能原因:key" message:@"内存不足" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [tip2 show];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[[UncaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.\n"
                         @"%@", nil),
       signal, getAppInfo()]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:UncaughtExceptionHandlerSignalKey]]
     waitUntilDone:YES];
    
}


@implementation UncaughtExceptionHandler

+(void) InstallUncaughtExceptionHandler
{
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
}
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}
- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        dismissed = YES;
    }
}
- (void)handleException:(NSException *)exception
{
    UIAlertView *alert =
    [[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
      message:[NSString stringWithFormat:NSLocalizedString(
                                                           @"You can try to continue but the application may be unstable.\n"
                                                           @"%@\n%@", nil),
               [exception reason],
               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"Quit", nil)
      otherButtonTitles:NSLocalizedString(@"Continue", nil), nil] ;
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed)
    {
        for (NSString *mode in (NSArray *)CFBridgingRelease(allModes))
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}
void UncaughtExceptionHandlers (NSException *exception) {
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    
    NSArray *callStackSymbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://wenhg@champor.com.cn?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "系统当前时间为：%@<br>-------------------------<br>异常名称：%@<br>--------------------------<br>异常原因：<br>%@<br>---------------------<br>%@<br><br>",dateStr,name,reason,[callStackSymbols componentsJoinedByString:@"<br>"]];
     
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
//    NSLog(@"1heqin, CRASH: %@", exception);
//    NSLog(@"heqin, Stack Trace: %@", [exception callStackSymbols]);
}

@end
