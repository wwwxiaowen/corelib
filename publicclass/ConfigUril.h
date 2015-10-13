//  Created by  on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#ifndef  ConfigUtil_h
#define  ConfigUtil_h

//URL 动态地址管理区--------------------------------------------------------------------
//#define  DEBUG_kaifa @"开发"
//#define  DEBUG_ceshi @"测试"
#define  DEBUG_fabu  @"正式发布"

#ifdef  DEBUG_kaifa
#define DEXIN_URL           @"http://service.ydbc360.com/"
#define DEXIN_HUANXIN       @"liangxd#xiaodong"
#define DEXIN_HUANXIN_APNS  @"MYTDoctorAPNSDis"
#endif

#ifdef  DEBUG_ceshi
#define DEXIN_URL           @"http://service.ydbc360.com/"
#define DEXIN_HUANXIN       @"champor#mingyitang"
#define DEXIN_HUANXIN_APNS  @"MYTDoctorAPNSDis"
#endif

#ifdef  DEBUG_fabu
#define DEXIN_URL           @"http://service.ydbc360.com/"
#define DEXIN_HUANXIN       @"champor#mingyitang"
#define DEXIN_HUANXIN_APNS  @"AppstoreANPSDoctorDis"
#endif
//-------------------------------------------------------------------------------------

#define DEXIN(METHOD)        [NSString stringWithFormat:@"%@%@",DEXIN_URL,METHOD]

#define albumListCellPhotoShowCount  3 //选照片每列显示多少张

#pragma mark - Passprot --------------------------------------------------------------
#define P_login                 @"mobDoctorAction/login"        //
#define P_findpassword          @"mobDoctorAction/findpassword"   //
#define P_getphonecode          @"commonAction/getphonecode"
#define P_getServicePhone       @"commonAction/getServiceData"





#endif
