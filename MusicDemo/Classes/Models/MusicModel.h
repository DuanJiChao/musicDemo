//
//  MusicModel.h
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

//MP3网址
@property(nonatomic,strong)NSString *mp3Url;
//ID
@property(nonatomic,strong)NSString *ID;
//歌曲名
@property(nonatomic,strong)NSString *name;
//图片地址
@property(nonatomic,strong)NSString *picUrl;
//歌手名
@property(nonatomic,strong)NSString *singer;
//音乐的时长
@property(nonatomic,strong)NSNumber *duration;
//歌词
@property(nonatomic,strong)NSString *lyric;
//背景图片
@property(nonatomic,strong)NSString *blurPicUrl;


@end



/*
<key>mp3Url</key>
<key>id</key>
<key>name</key>
<key>picUrl</key>
<key>singer</key>
<key>duration</key>
<key>lyric</key>
*/
