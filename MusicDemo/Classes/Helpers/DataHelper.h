//
//  DataHelper.h
//  MusicDemo
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;//只是声明一下，防止报错，并不引进，只是用一下类名。必要的话引入写到.M文件里面。编程规范。
@interface DataHelper : NSObject

//当歌曲列表加载完成后，回调。  ----- ARC下copy和strong一样。
@property(nonatomic,copy) void(^ResuktBlock)();

//歌曲的个数
@property(nonatomic,assign)NSInteger count;

//根据indexPath获取到musicModel
-(MusicModel *)getMusicModelFronIndexPath:(NSIndexPath *)indexPath;

//根据下标获取musicModel
-(MusicModel *)getMusicModelFronIndex:(NSInteger)index;

//单例方法
+(instancetype)shareDataHelper;


//面向对象简单来说就是面向接口



@end
