//
//  LyricModel.m
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

-(void)dealloc{
    self.time = 0;
    self.string = nil;
}


-(instancetype)initWithTime:(NSInteger)time andString:(NSString *)string{
    if (self = [super init]) {
        self.time = time;
        self.string = string;
    }
    return self;
}

+(instancetype)instantateWithTime:(NSInteger)time andString:(NSString *)string{
    return [[LyricModel alloc]initWithTime:time andString:string];
}



@end
