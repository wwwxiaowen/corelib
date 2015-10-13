//
//  NSArray+Safe.m
//  SafeArray
//
//  Created by qiu  on 14-3-10.
//  Copyright (c) 2014年 qiu . All rights reserved.
//

#import "SafeMode.h"

@implementation SafeMode

+ (void)safe
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //NSArray
        [self exchangeOriginalMethod:[NSArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSArray methodOfSelector:@selector(objectAtIndexOrNil:)]];
        
        //NSMutableArray
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(objectAtIndexOrNilM:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(replaceObjectAtIndex:withObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_replaceObjectAtIndex:withObject:)]];
        
        //NSMutableDictionary
        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(setObject:forKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(safe_setObject:forKey:)]];
        
        //UIView
        [self exchangeOriginalMethod:[UIView methodOfSelector:@selector(addSubview:)] withNewMethod:[UIView methodOfSelector:@selector(safe_addSubview:)]];
    });
}

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod
{
    method_exchangeImplementations(originalMethod, newMethod);
}

@end

@implementation NSArray (Safe)

#pragma mark - NSArray
+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"),selector);
}


- (id)objectAtIndexOrNil:(NSUInteger)index
{
    if(index < [self count]){
        return [self objectAtIndexOrNil:index];
    }else{
        NSLog(@"CUOWUXIXNXNXX");
        return    nil;
    }
//    return (index < [self count]) ? [self objectAtIndexOrNil:index] : nil;
}

@end


@implementation NSMutableArray (Safe)


#pragma mark - NSMutableArray
+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"),selector);
}

- (id)objectAtIndexOrNilM:(NSUInteger)index
{ 
//    return (index < [self count]) ? [self objectAtIndexOrNilM:index] : nil;

    if(index < [self count]){
        return [self objectAtIndexOrNilM:index];
    }else{
        NSLog(@"CUOWUXIXNXNXX");
      return    nil;
    }
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ((index < [self count])&&anObject) {
        [self safe_replaceObjectAtIndex:index withObject:anObject];
    }
}

@end


#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"),selector);
}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject) {
        [self safe_setObject:anObject forKey:aKey];
    }
    else
    {
        [self removeObjectForKey:aKey];
    }
}

@end

#pragma mark - UIView
@implementation UIView (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"UIView"),selector);
}

- (void)safe_addSubview:(UIView *)view
{
    if (self!=view) {
        [self safe_addSubview:view];
    }
}

@end

