//
//  LyricModel.h
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject


//时间
@property(nonatomic,assign)NSInteger time;
//歌词内容
@property(nonatomic,strong)NSString *string;

-(instancetype)initWithTime:(NSInteger)time andString:(NSString *)string;

+(instancetype)instantateWithTime:(NSInteger)time andString:(NSString *)string;



@end
