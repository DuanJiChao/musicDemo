//
//  PlayerHelper.h
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *播放状态的代理
 */
@protocol PlayerHelperDelegate <NSObject>

/**
 *正在播放音乐
 */
-(void)playerDidPlay:(float)time;

//播放完成
-(void)playerDidFinish;


@end




@interface PlayerHelper : NSObject



//代理属性(ARC 用 weak   MRC用assign)
@property(nonatomic,weak)id<PlayerHelperDelegate>delegate;


//音量
@property(nonatomic,assign)float volume;
//歌曲下标
@property(nonatomic,assign)NSInteger musicIndex;

//改变播放进度
-(void)seekToTime:(NSInteger)time;

//播放暂停
-(void)play;
-(void)pause;


//根据下标放歌曲
-(void)playMusicWithIndex:(NSInteger)index;


//实现单例
+(instancetype)sharePlayer;

@end
