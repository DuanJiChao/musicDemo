//
//  PlayerHelper.m
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import "PlayerHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicModel.h"
#import "DataHelper.h"
@interface PlayerHelper()
//播放器属性
@property(nonatomic,strong)AVPlayer *avPlayer;

//当前下标
@property(nonatomic,assign)NSInteger currentIndex;

//播放状态的属性
@property(nonatomic,assign)BOOL isPlay;

@end

@implementation PlayerHelper

//懒加载
-(AVPlayer *)avPlayer{
    if (!_avPlayer) {
        _avPlayer = [[AVPlayer alloc]init];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(performDelegationAction) userInfo:nil repeats:YES];
    }
    return _avPlayer;
}

//调用代理
-(void)performDelegationAction{
    if (self.avPlayer.rate) {
        if ([self.delegate respondsToSelector:@selector(playerDidPlay:)]) {
            //当前播放的时间
            NSInteger time = self.avPlayer.currentTime.value/self.avPlayer.currentTime.timescale;
            
            [self.delegate playerDidPlay:time];
            self.isPlay = YES;
        }
    }else if(self.isPlay && !self.avPlayer.rate){
        //完成播放调用完成代理方法
        if ([self.delegate respondsToSelector:@selector(playerDidFinish)]) {
            [self.delegate playerDidFinish];
            self.isPlay = NO;
        }
        
    }
    
    
}

//实现单例类
+(instancetype)sharePlayer{
    static PlayerHelper *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[PlayerHelper alloc]init];
        player.currentIndex = -1;
    });
    return player;
}

//音量 set方法

-(void)setVolume:(float)volume{
    self.avPlayer.volume = volume;
}

//get方法
-(float)volume{
    return self.avPlayer.volume;
}

//下标 set方法
-(void)setMusicIndex:(NSInteger)musicIndex{
    if (self.currentIndex != musicIndex) {
        _musicIndex = musicIndex;
        _currentIndex = musicIndex;
        //播放此下标对应的歌曲
        MusicModel *music = [[DataHelper shareDataHelper] getMusicModelFronIndex:musicIndex];
        //创建AVPlayerItem
        AVPlayerItem *currenItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:music.mp3Url]];
        //将此Item播放
        [self.avPlayer replaceCurrentItemWithPlayerItem:currenItem];
        [self.avPlayer play];
    }
}

-(void)playMusicWithIndex:(NSInteger)index{
    self.musicIndex = index;
}

//播放
-(void)play{
    [self.avPlayer play];
    self.isPlay = YES;
}

//暂停
-(void)pause{
    [self.avPlayer pause];
    self.isPlay = NO;
}

//播放进度

-(void)seekToTime:(NSInteger)time{
    if (self.isPlay) {
        
    //先暂停播放当前歌曲
    [self pause];
    //改变播放进度
    [self.avPlayer seekToTime:CMTimeMake(time * self.avPlayer.currentTime.timescale, self.avPlayer.currentTime.timescale)];
    //继续播放
        [self play];
    }else{
        [self.avPlayer seekToTime:CMTimeMake(time * self.avPlayer.currentTime.timescale, self.avPlayer.currentTime.timescale)];
    }

}
















@end
