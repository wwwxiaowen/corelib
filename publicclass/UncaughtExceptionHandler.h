//
//  UncaughtExceptionHandler.h
//  MYTDoctor
//
//  Created by 温火光 on 15/7/1.
//  Copyright (c) 2015年 dexingrongtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}
- (void) handleException:(NSException *)exception;
+ (NSArray *) backtrace;
+ (void) InstallUncaughtExceptionHandler;
void UncaughtExceptionHandlers(NSException *exception) ;
@end


//#import "UncaughtExceptionHandler.h"
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    [UncaughtExceptionHandler InstallUncaughtExceptionHandler];
//    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandlers);