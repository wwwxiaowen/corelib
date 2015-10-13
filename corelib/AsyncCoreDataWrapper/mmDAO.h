//
//  mmDAO.h
//  agent
//
//  Created by LiMing on 14-6-24.
//  Copyright (c) 2014年 bangban. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationResult)(NSError* error);

@interface mmDAO : NSObject
@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

+(mmDAO*)instance;
-(void) setupEnvModel:(NSString *)model DbFile:(NSString*)filename;
- (NSManagedObjectContext *)createPrivateObjectContext;
-(NSError*)save:(OperationResult)handler;

@end


// didFinishLaunchingWithOptions
// [[mmDAO instance] setupEnvModel:@"asyncCoreDataWrapper" DbFile:@"asyncCoreDataWrapper.sqlite"];


//-(void)fetchEntitys{
//    /* 简单异步查询模式
//     [Entity filter:nil orderby:@[@"task_id"] offset:0 limit:0 on:^(NSArray *result, NSError *error) {
//     //
//     _dataArray = result;
//     [_mainTable reloadData];
//     }];
//     */
//    [Entity async:^id(NSManagedObjectContext *ctx, NSString *className) {
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
//        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"task_id" ascending:YES]]];
//        NSError *error;
//        NSArray *dataArray = [ctx executeFetchRequest:request error:&error];
//        if (error) {
//            return error;
//        }else{
//            return dataArray;
//        }
//        
//    } result:^(NSArray *result, NSError *error) {
//        _dataArray = result;
//        [_mainTable reloadData];
//    }];
//}


//- (IBAction)addNewClick:(id)sender {
//    if ([_txInputBox.text length]<1) {
//        return;
//    }
//    [self hideInputBar];
//    
//    Entity *task = [Entity createNew];
//    task.task_id = @([self genId]);
//    task.title = _txInputBox.text;
//    task.detail = @"[not sure]";
//    task.done = NO;
//    [Entity save:^(NSError *error) {
//        _txInputBox.text = @"";
//        [self fetchEntitys];
//    }];
//}


//Entity *task = _dataArray[indexPath.row];
//[Entity delobject:task];
//[tableView setEditing:NO animated:YES];
//[Entity save:^(NSError *error) {
//    [self fetchEntitys];
//}];