//
//  MusicModel.m
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

//ARC里面只是调用 super dealloc，不释放本身的属性，释放时需要先把属性置为nil。
-(void)dealloc{
    self.mp3Url = nil;
    self.ID = nil;
    self.name = nil;
    self.singer = nil;
    self.picUrl = nil;
    self.lyric = nil;
    self.duration = nil;
    self.blurPicUrl = nil;
}
//xcode5.5.1之前, 电脑mac系统就有垃圾回收机制，IOS中一直没有。现在都是用 引用计数制（MRC   ARC）

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}




@end
