//
//  SafeMode.h
//  SafeArray
//
//  Created by qiu  on 14-3-10.
//  Copyright (c) 2014年 qiu . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SafeMode:NSObject
+ (void)safe;
+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod;
@end
 
@interface NSArray (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (id)objectAtIndexOrNil:(NSUInteger)index;
@end


@interface NSMutableArray (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (id)objectAtIndexOrNilM:(NSUInteger)index;
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end


@interface NSMutableDictionary (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end

@interface UIView (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (void)safe_addSubview:(UIView *)view;
@end
