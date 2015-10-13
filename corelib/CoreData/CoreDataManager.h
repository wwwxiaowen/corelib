//
//  CoreDataManager.h
//  CoreData
//
//  Created by Jone ji on 15/4/21.
//  Copyright (c) 2015年 Jone ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ManagerObjectModelFileName @"UserModel"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *perStoreCoordinator;

+ (instancetype) sharedCoreDataManager;

- (void)saveContext;

@end


//取数据
////    创建取回数据请求
//NSFetchRequest *request = [[NSFetchRequest alloc] init];
////    设置要检索哪种类型的实体对象
//NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_manager.managedObjContext];
////    设置请求实体
//[request setEntity:entity];
//
////    指定对结果的排序方式
//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:NO];
//NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//[request setSortDescriptors:sortDescriptions];
//
//NSError *error = nil;
////    执行获取数据请求，返回数组
//NSArray *fetchResult = [_manager.managedObjContext executeFetchRequest:request error:&error];
//if (!fetchResult)
//{
//    NSLog(@"error:%@,%@",error,[error userInfo]);
//}
//[self.dataArr removeAllObjects];
//[self.dataArr addObjectsFromArray:fetchResult];

//存储
//_user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
//[_user setName:self.tfName.text];
//[_user setSex:self.tfSex.text];
//[_user setAge:@([self.tfAge.text integerValue])];
//NSError *error = nil;
//
////    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
//BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
//if (!isSaveSuccess) {
//    NSLog(@"Error: %@,%@",error,[error userInfo]);
//}else
//{
//    NSLog(@"Save successFull");
//}


//修改
//[_user setName:self.tfName.text];
//[_user setSex:self.tfSex.text];
//[_user setAge:@([self.tfAge.text integerValue])];
//NSError *error = nil;
//
////    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
//BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
//if (!isSaveSuccess) {
//    NSLog(@"Error: %@,%@",error,[error userInfo]);
//}else
//{
//    NSLog(@"Change successFull");
//}



//删除
//[[CoreDataManager sharedCoreDataManager].managedObjContext deleteObject:_user];
//
//NSError *error = nil;
//
////    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
//BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
//if (!isSaveSuccess) {
//    NSLog(@"Error: %@,%@",error,[error userInfo]);
//}else
//{
//    NSLog(@"del successFull");
//    
//    _tfName.text = @"";
//    _tfSex.text = @"";
//    _tfAge.text = @"";
//}



