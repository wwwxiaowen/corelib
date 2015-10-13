//
//  NSObject+SafeKit.h
//  SafeKitExample
//
//  Created by zhangyu on 14-2-28.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    SafeKitObjectPerformExceptionCatchOn,
    SafeKitObjectPerformExceptionCatchOff
} SafeKitObjectPerformExceptionCatch;

void setSafeKitObjectPerformExceptionCatch(SafeKitObjectPerformExceptionCatch type);
SafeKitObjectPerformExceptionCatch getSafeKitObjectPerformExceptionCatch();

@interface NSObject(SafeKit_Perform)
@end

@interface NSObject(SafeKit_KVO)
@end
