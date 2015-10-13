//
//  ShareView.m
//  LovePicture
//
//  Created by 温火光 on 15/7/9.
//  Copyright (c) 2015年 dexingrongtong. All rights reserved.
//

#import "ShareView.h"
#import "OpenShareHeader.h"

@implementation ShareView

- (OSMessage *)shareModelTemplete{
    OSMessage *msg = [[OSMessage alloc] init];
    msg.title = @"医到病除是一款慢性病的院外管理平台";
    msg.image = UIImageJPEGRepresentation([UIImage imageNamed:@"yidao"], 0.6);
    msg.thumbnail = UIImageJPEGRepresentation([UIImage imageNamed:@"yidao"], 0.6);
    msg.desc= @"它是医生的院外管理助手,病友的自我管理神器... 医到病除 医到病除 下载链接 医到微信 节约就医成本,省时省力 得了糖尿病";
    msg.link= [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/hao-de-kuai/id%@?mt=8",@"992328588"];
    return msg;
}

- (IBAction)selectWeixin:(id)sender{
  [self removeFromSuperview];
    [OpenShare shareToWeixinSession:[self shareModelTemplete] Success:^(OSMessage *message) {
        NSLog(@"微信分享到会话成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"微信分享到会话失败：\n%@\n%@",error,message);
    }];
}

- (IBAction)selectQQ:(id)sender{
  [self removeFromSuperview];
//    [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
//        NSLog(@"QQ登录成功\n%@",message);
//    } Fail:^(NSDictionary *message, NSError *error) {
//        NSLog(@"QQ登录失败\n%@\n%@",error,message);
//    }];
    [OpenShare shareToQQFriends:[self shareModelTemplete] Success:^(OSMessage *message) {
        NSLog(@"分享到QQ好友成功:%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享到QQ好友失败:%@\n%@",message,error);
    }]; 
}
- (IBAction)selectWeixinFriend:(id)sender{
    [self removeFromSuperview];
    [OpenShare shareToWeixinTimeline:[self shareModelTemplete] Success:^(OSMessage *message) {
        NSLog(@"微信分享到朋友圈成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
    }];
}
- (IBAction)selectSina:(id)sender{
    [self removeFromSuperview];
    [OpenShare shareToWeibo:[self shareModelTemplete] Success:^(OSMessage *message) {
        NSLog(@"分享到sina微博成功:\%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享到sina微博失败:\%@\n%@",message,error);
    }];
}

- (void)shareviewshow{
    self.bgImg.alpha = 0.0f;
    self.shareView.frame = CGRectMake(0,self.frame.size.height, kWindowWidth, 200);
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImg.alpha = 0.5f;
        self.shareView.frame = CGRectMake(0,self.frame.size.height-200, kWindowWidth, 200);
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)cancelShare:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgImg.alpha = 0.0f;
        self.shareView.frame = CGRectMake(0,self.frame.size.height, kWindowWidth, 200);
    } completion:^(BOOL finished) {
      [self removeFromSuperview];
    }];
    
}
- (IBAction)handTap:(UITapGestureRecognizer*) gesture{
    [self cancelShare:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
