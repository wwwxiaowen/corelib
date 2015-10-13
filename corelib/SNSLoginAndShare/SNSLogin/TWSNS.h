//
//  XTSNS.h
//  XTSNS
//
//  Created by 何振东 on 15/9/9.
//  Copyright © 2015年 LZA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWShare.h"
#import "TWShareView.h"
#import "TWOAuth.h"
#import "OpenShareHeader.h"
#import "OpenShare.h"
#import "TWSNSDefine.h"

@interface TWSNS : NSObject

//注册相应平台的信息
+ (void)registerWeiboAppId:(NSString *)appId secret:(NSString *)secret redirectURI:(NSString *)redirectURI;
+ (void)registerQQAppId:(NSString *)appId secret:(NSString *)secret;
+ (void)registerWeiXinAppId:(NSString *)appId secret:(NSString *)secret;

@end

//1.第一步
//
//#import "TWSNS.h"
//#import "NSString+SNSAddition.h"
//
////#warning 请替换为自己的相关帐号进行测试
/////微信第三方登录
//static NSString *const kWeiXinAppId         = @"wx5bc067c5c1073564";
//static NSString *const kWeiXinAppSecret     = @"773569756f5b73aca618e12866b0a5bc";
//
/////微博第三方登录
//static NSString *const kWeiBoAppId          = @"2505657114";
//static NSString *const kWeiBoAppSecret      = @"";
//static NSString *const kWeiBoAppRedirectURL = @"http://sns.whalecloud.com/sina2/callback";
//
/////QQ第三方登录
//static NSString *const kQQAppId          = @"1103288905";
//static NSString *const kQQAppKey         = @"";
//
//2.- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中添加下面代码
//
//[TWSNS registerQQAppId:kQQAppId secret:kQQAppKey];
//[TWSNS registerWeiboAppId:kWeiBoAppId secret:kWeiBoAppSecret redirectURI:kWeiBoAppRedirectURL];
//[TWSNS registerWeiXinAppId:kWeiXinAppId secret:kWeiXinAppSecret];
//
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([OpenShare handleOpenURL:url]) {
//        return YES;
//    }
//    return NO;
//}
//
//3. 触发函数
//#import "TWSNS.h"
//- (IBAction)share:(id)sender
//{
//    OSMessage *message = [[OSMessage alloc] init];
//    message.title = @"我爱我的因我觉得欢喜~~~这里是你要分享的内容";
//    message.image = UIImageJPEGRepresentation([UIImage imageNamed:@"aboutbgbottom@2x.png"], 0.1);
//    message.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"aboutbgbottom@2x.png"], 0.1);
//    message.desc = @"哈哈，这里是描述";
//    message.link = @"http://www.3water3.com";
//    [[TWShareView shareView] showShareViewWithMessage:message completionHandler:^(OSMessage *message, NSError *error) {
//        NSLog(@"message:%@", message);
//        NSLog(@"error:%@", error);
//    }];
//}
//
//- (IBAction)qqLogin:(id)sender {
//    [TWOAuth loginToPlatform:TWSNSPlatformQQ completionHandle:^(NSDictionary *data, NSError *error)
//     {
//         NSLog(@"data:%@", data);
//         NSLog(@"error:%@", error);
//     }];
//}
//
//- (IBAction)weiboLogin:(id)sender {
//    [TWOAuth  loginToPlatform:TWSNSPlatformWeibo completionHandle:^(NSDictionary *data, NSError *error)
//     {
//         NSLog(@"data:%@", data);
//         NSLog(@"error:%@", error);
//     }];
//}
//
//- (IBAction)weixinLogin:(id)sender {
//    [TWOAuth loginToPlatform:TWSNSPlatformWeiXin completionHandle:^(NSDictionary *data, NSError *error)
//     {
//         NSLog(@"data:%@", data);
//         NSLog(@"error:%@", error);
//     }];
//}




