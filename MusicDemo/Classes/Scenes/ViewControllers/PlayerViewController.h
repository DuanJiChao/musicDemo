//
//  PlayerViewController.h
//  MusicDemo
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController
//歌曲下标
@property (nonatomic,assign)NSInteger musicIndex;

//单类获取方法
+(instancetype)sharePlayerVC;








@end
