//
//  LyricHelper.h
//  MusicDemo
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHelper : NSObject

//行数
@property(nonatomic,assign)NSInteger count;



//单例
+(instancetype)shareLyricHelper;
//根据时间获取对应下标
-(NSInteger)indexWithTime:(NSInteger)time;

//根据下标获取对应的歌词
-(NSString *)stringWithIndex:(NSInteger)index;

//将字符串转为歌词数组
-(void)serializeString:(NSString *)string;


@end
