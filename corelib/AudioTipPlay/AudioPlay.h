//
//  AudioPlay.h
//  HuivoSwiftTeacher
//
//  Created by HuivoNo1 on 14-12-7.
//  Copyright (c) 2014年 com.huivo.swiftTeacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioPlay : NSObject{
    
}
@property (nonatomic, assign)BOOL isPlay;

+(AudioPlay *)shareAudioPlay;
- (void)playSound:(NSString *)audioName;//多次同时播放,不重叠
- (void)playSoundContinue:(NSString *)audioName; //多次同时播放,重叠
void finishPalySoundCallBack(SystemSoundID sound_id,void* user_data);
void finishPalySoundCallBack1(SystemSoundID sound_id,void* user_data);
@end
