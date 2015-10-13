//
//  DBManger.m
//  FMDB-encrypt
//
//  Created by wuyj on 14-10-19.
//  Copyright (c) 2014年 baidu. All rights reserved.
//



#import "DBManger.h"
#import "FMDatabase.h"


@interface DBManger ()
@property(nonatomic,strong)FMDatabase *db;
@end


@implementation DBManger

-(BOOL)openDB:(NSString*)filePath{
    self.db = [FMDatabase databaseWithPath:filePath];
    //
    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    return YES;
}

-(NSArray *)executeSQL:(NSString*)dbFile KEY:(NSString*)key SQL:(NSString*)sql{
    
    BOOL bSuc = [self openDB:dbFile];
    if (!bSuc) {
        return nil;
    }
    
    if(key != nil && [key length] > 0){
        [_db setKey:key];
    }
    
    
    [_db setShouldCacheStatements:YES];
    FMResultSet *rs = [_db executeQuery:sql];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:0];
    
    NSInteger index = 1;
    while ([rs next]) {
        NSMutableDictionary * dic = [rs columnNameToIndexMap];
        NSArray *keys = [dic allKeys];
        NSMutableDictionary* item = [[NSMutableDictionary alloc] initWithCapacity:0];

        if (keys != nil && [keys count] > 0) {
            [item setObject:[NSNumber numberWithInteger:index] forKey:indexIdentifier];
            for (int i = 0; i < [keys count]; i ++) {
                NSString *key = [keys objectAtIndex:i];
                NSString *valueString = [rs stringForColumn:key];
                if (valueString!= nil && [valueString length] > 0) {
                    [item setObject:valueString forKey:key];
                }
            }
            
            [resultArray addObject:item];
        }
        
        index ++;
    }
    
    [self closeDB];
    if ([resultArray count] > 0) {
         return resultArray;
    }
    return nil;
}

-(void)closeDB{
    [_db close];
}

@end
