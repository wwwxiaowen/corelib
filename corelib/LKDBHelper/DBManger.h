//
//  DBManger.h
//  FMDB-encrypt
//
//  Created by wuyj on 14-10-19.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const indexIdentifier = @"wuyj_index";


@interface DBManger : NSObject


-(BOOL)openDB:(NSString*)filePath;
-(NSArray *)executeSQL:(NSString*)dbFile KEY:(NSString*)key SQL:(NSString*)sql;
-(void)closeDB;

@end
