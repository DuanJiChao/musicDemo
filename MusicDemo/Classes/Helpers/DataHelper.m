//
//  DataHelper.m
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import "DataHelper.h"
#import "MusicModel.h"
#import "Urls.h"
#import <UIKit/UIKit.h>

@interface DataHelper()
//存取歌曲列表
@property(nonatomic,strong)NSMutableArray *musicArray;
@end

@implementation DataHelper

//懒加载
-(NSMutableArray *)musicArray{
    if (!_musicArray) {
        _musicArray = [NSMutableArray new];
    }
    return _musicArray;
}


//获取单例方法
+(instancetype)shareDataHelper{
    static DataHelper *dataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化
        dataHelper = [[DataHelper alloc]init];
        //调用获取歌曲列表方法
        [dataHelper requestMusicList];
        
    });
    return dataHelper;
}


//获取歌曲列表
-(void)requestMusicList{
    //1 子线程
    dispatch_async(dispatch_get_main_queue(), ^{
    //获取plist文件
       NSArray *plistArray = [[NSArray alloc]initWithContentsOfURL:[NSURL URLWithString:kMusicUrl]];
        for (NSDictionary *musicDic in plistArray) {
            MusicModel *music = [[MusicModel alloc]init];
            [music setValuesForKeysWithDictionary:musicDic];
            [self.musicArray addObject:music];   //因为懒加载，所以数组是在这个时候才被创建
        }
        //判断(安全机制)   回调block
     //   NSLog(@"%ld",self.musicArray.count);
        if (self.ResuktBlock) {
            self.ResuktBlock();
        }
    });
}


//歌曲个数
-(NSInteger)count{
    return self.musicArray.count;
}

#pragma mark --- 短发水电费啊打发啊打发短发
//根据indexPath获取music
-(MusicModel *)getMusicModelFronIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row >= 0 && indexPath.row < self.musicArray.count) {
//        return self.musicArray[indexPath.row];
//    }
//    return nil;
    return [self getMusicModelFronIndex:indexPath.row];
}


//根据index获取music
-(MusicModel *)getMusicModelFronIndex:(NSInteger)index{
    if (index >= 0 && index < self.musicArray.count) {
        return self.musicArray[index];
    }
    return nil;
}
















@end
