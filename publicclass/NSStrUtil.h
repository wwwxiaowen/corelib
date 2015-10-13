//
//  StrUtil.h
//  OrderFood
//
//  Created by Berwin on 13-4-10.
//  Copyright (c) 2013年 Berwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStrUtil : NSObject

//判空处理
+ (BOOL) isEmptyOrNull:(NSString*) string;
 
//校验手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//字母数字3-20位
+ (BOOL)isUserName:(NSString *)str;

//字母数字6-20位
+(BOOL)isPassword:(NSString *)str;

//邮件地址
+(BOOL)isEmail:(NSString *)str;

//http | https 
+ (BOOL)isUrl:(NSString *)str;

//是否中文
+(BOOL)isChinese:(NSString *)str


//去空白字符
+ (NSString *)trimString:(NSString *) str;

//获取富文本的高度
+ (int)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width;

/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;


/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

//创建路径文件夹
+(BOOL) createFolderByPath:(NSString *)folderPath;

//读取文件路径
+(NSString *)getConfigFile:(NSString *)fileName;

//获取app自带资源路径
+ (NSString*) pathForResource:(NSString*)resourcepath;

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;

+(NSString*) urlEncodedString:(NSString *)str;

@end


@interface NSString (MyExtensions)
- (NSString *) md5;
- (NSString *) md5_16:(NSString *)str;

- (NSString *)sha1;

/* document根文件夹 */
+(NSString *)documentFolder;

/* caches根文件夹  */
+(NSString *)cachesFolder;

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;

@end

@interface NSData (MyExtensions)
- (NSString*)md5;
+ (NSData *)base64DataFromString:(NSString *)string;
@end
