//
//  LyricHelper.m
//  MusicDemo
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import "LyricHelper.h"

#include "LyricModel.h"

@interface LyricHelper()

//歌词的数组
@property(nonatomic,strong)NSMutableArray *lyricArray;



@end






@implementation LyricHelper


//懒加载
-(NSMutableArray *)lyricArray{
    if (!_lyricArray) {
        _lyricArray = [NSMutableArray new];
    }
    return _lyricArray;
}

//单例实现
+(instancetype)shareLyricHelper{
    static LyricHelper *lyrichelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyrichelper = [[LyricHelper alloc]init];
    });
    return lyrichelper;
}

//count set方法
-(NSInteger)count{
    return self.lyricArray.count;
}

//解析字符串
-(void)serializeString:(NSString *)string{
    NSArray *arr = [string componentsSeparatedByString:@"\n"];
    //清空上首歌的歌词
    [self.lyricArray removeAllObjects];
    for (NSString *lyricString in arr) {
        //根据“]”分段，第一个是时间，第二个是歌词
        NSArray *lyricStrArray = [lyricString componentsSeparatedByString:@"]"];
        if (lyricStrArray.count <= 1) {
            continue;
        }
        
        //根据“:”分段，第一个是分，第二个是秒
        NSArray *timeArray = [lyricStrArray[0] componentsSeparatedByString:@":"];
        NSInteger minute = [[timeArray[0] substringFromIndex:1] integerValue];
        NSInteger time = minute * 60 + [timeArray[1]  integerValue];
   //     NSLog(@"!!!!%d",time);
        //创建歌词模型
        LyricModel *lyric = [LyricModel instantateWithTime:time andString:lyricStrArray[1]];
        
        //添加到歌词数组
        [self.lyricArray addObject:lyric];   
    }
}

//根据时间获取对应下标
-(NSInteger)indexWithTime:(NSInteger)time{
    for (int i = 0; i <self.lyricArray.count; i++) {
        if (time < [self.lyricArray[i] time]) {
            return i - 1 < 0 ? 0 : i - 1;
        }
    }
    return 0;
}

//根据下标获取对应的歌词
-(NSString *)stringWithIndex:(NSInteger)index{
    return [self.lyricArray[index] string];
}

////将字符串转为歌词数组
//-(void)serializeString:(NSString *)string{
//    
//}






@end
