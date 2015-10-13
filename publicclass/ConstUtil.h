//  Created by  on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#ifndef  ConstUtil_h
#define  ConstUtil_h


//设置信息------------------------------------------------------------------
#define APP_Name                @"名医堂.医生"
#define APP_AppstoreId          @"992328588"
#define AppVersionCode          @"1"


//userdefaults UDKEY_ 开头命名 ---------------------------------------------------------
#define defaults                 [NSUserDefaults standardUserDefaults]

//  非常注意 －－－－初始值问题 | 用户切换问题
#define UDKEY_USER_ID             @"UDKEY_USER_ID"               //用户id
#define UDKEY_LONGIN_MOBILE_PHONE @"UDKEY_LONGIN_MOBILE_PHONE"   //登录名
#define UDKEY_USER_ROLE           @"UDKEY_USER_ROLE"             //管理员 主治医师 患者
#define UDKEY_USER_SEX            @"UDKEY_USER_SEX"              //用户性别
#define UDKEY_AVATAR_URL          @"UDKEY_AVATAR_URL"            //用户头像

#define UDKEY_DOCTOR_NAME         @"UDKEY_DOCTOR_NAME"           //医生名
#define UDKEY_DOCTOR_AVATAR       @"UDKEY_DOCTOR_AVATAR"         //医生名头像
#define UDKEY_DOCTOR_CONNECT      @"UDKEY_DOCTOR_CONNECT"        //是否关联医生

#define UDKEY_LOGIN               @"UDKEY_LOGIN"                 //是否需要登录
#define UDKEY_LONGIN_PASSWORD     @"UDKEY_LONGIN_PASSWORD"       //登录密码
#define UDKEY_IS_FIRST_LAUNCH     @"UDKEY_IS_FIRST_LAUNCH"       //是否第一次开启程序

#define UDKEY_IS_TALKING          @"UDKEY_IS_TALKING"            //是否正在聊天
#define UDKEY_TALKING_MSG_UNREAD  @"UDKEY_TALKING_MSG_UNREAD"    //未读聊天消息数


#define UDKEY_USER_DEFAULT_COOKIES @"UDKEY_USER_DEFAULT_COOKIES" //登录用户cookies

//通知 都以  NNKEY_  开头命名 ---------------------------------------------------------------
#define NNKEY_NETWORK_HAVE_CHANGE_NOTIFICATION    @"NNKEY_NETWORK_HAVE_CHANGE_NOTIFICATION" //网络通知0为无网,1为2G/3G
#define NNKEY_REFRESH_HOMELIST_BY_CLASS_NAME      @"NNKEY_REFRESH_HOMELIST_BY_CLASS_NAME"  //根据类名刷新主界面数据



#endif
