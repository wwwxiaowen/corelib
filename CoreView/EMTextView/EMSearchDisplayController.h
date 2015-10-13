/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
  
@interface EMSearchDisplayController : UISearchDisplayController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *resultsSource;

//编辑cell时显示的风格，默认为UITableViewCellEditingStyleDelete；会将值付给[tableView:editingStyleForRowAtIndexPath:]
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

@property (copy) UITableViewCell * (^cellForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didDeselectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);

@end


/*
 
 
 - (EMSearchDisplayController *)searchController
 {
 if (_searchController == nil) {
 _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
 _searchController.delegate = self;
 _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
 __weak ChatListViewController *weakSelf = self;
 [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
 static NSString *CellIdentifier = @"ChatListCell";
 ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 // Configure the cell...
 if (cell == nil) {
 cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
 cell.name = conversation.chatter;
 if (!conversation.isGroup) {
 cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
 }
 else{
 NSString *imageName = @"groupPublicHeader";
 NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
 for (EMGroup *group in groupArray) {
 if ([group.groupId isEqualToString:conversation.chatter]) {
 cell.name = group.groupSubject;
 imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
 break;
 }
 }
 cell.placeholderImage = [UIImage imageNamed:imageName];
 }
 cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
 cell.time = [weakSelf lastMessageTimeByConversation:conversation];
 cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
 if (indexPath.row % 2 == 1) {
 cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
 }else{
 cell.contentView.backgroundColor = [UIColor whiteColor];
 }
 return cell;
 }];
 
 [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
 return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
 }];
 
 [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 [weakSelf.searchController.searchBar endEditing:YES];
 
 EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
 ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:conversation.isGroup];
 chatVC.title = conversation.chatter;
 [weakSelf.navigationController pushViewController:chatVC animated:YES];
 }];
 }
 
 return _searchController;
 }



*/