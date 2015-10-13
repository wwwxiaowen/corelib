//
//  AudioPlay.m
//  HuivoSwiftTeacher
//
//  Created by HuivoNo1 on 14-12-7.
//  Copyright (c) 2014年 com.huivo.swiftTeacher. All rights reserved.
//

#import "AudioPlay.h"

@implementation AudioPlay

@synthesize isPlay;

+(AudioPlay *)shareAudioPlay{
    static dispatch_once_t pred = 0;
    static AudioPlay *play = nil;
    dispatch_once(&pred,
                  ^{
                      play = [[AudioPlay alloc] init];
                  });
    return play;
}
- (id)init{
    self = [super init];
    if (self) {
        isPlay = NO;
    }
    return self;
}

void finishPalySoundCallBack(SystemSoundID sound_id,void* user_data){
    AudioServicesDisposeSystemSoundID(sound_id);
    AudioPlay *audio = (__bridge AudioPlay*)user_data;
    audio.isPlay = NO;
}
void finishPalySoundCallBack1(SystemSoundID sound_id,void* user_data){
    AudioServicesDisposeSystemSoundID(sound_id);
}
/* 一段时间内只能播放一种声音,可播放声音名字列表如下:
alert
btn_open
chatcome
message
silence
ZBar_scan
 
*/
- (void)playSound:(NSString *)audioName{
    if (!isPlay) {
        isPlay = YES;
        //第一步创建一个声音的路径
        NSURL *system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audioName ofType:@"wav"]];
        //第二步：申明一个sound id对象
        SystemSoundID system_sound_id;
        //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url, &system_sound_id);
        
        //第三步：创建一个回调方法，用于完成声音播放后需要做的事情
        
        AudioServicesAddSystemSoundCompletion(
                                              system_sound_id,
                                              NULL, NULL,
                                              finishPalySoundCallBack,
                                              (__bridge void*)self
                                              );
        //第四步：播放声音
        AudioServicesPlaySystemSound(system_sound_id);
    }
}

- (void)playSoundContinue:(NSString *)audioName{
    //第一步创建一个声音的路径
    NSString *wavAudioPath = [[NSBundle mainBundle] pathForResource:audioName ofType:@"wav"];
    if (!wavAudioPath) {
        return;
    }
    NSURL *system_sound_url = [NSURL fileURLWithPath:wavAudioPath];
    
    //第二步：申明一个sound id对象
    SystemSoundID system_sound_id;
    //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url, &system_sound_id);
    
    //第三步：创建一个回调方法，用于完成声音播放后需要做的事情
    
    AudioServicesAddSystemSoundCompletion(
                                          system_sound_id,
                                          NULL, NULL,
                                          finishPalySoundCallBack1,
                                          NULL
                                          );
    //第四步：播放声音
    AudioServicesPlaySystemSound(system_sound_id);
}

@end
