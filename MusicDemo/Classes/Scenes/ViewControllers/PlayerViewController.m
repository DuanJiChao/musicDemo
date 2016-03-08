//
//  PlayerViewController.m
//  MusicDemo
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 段继超. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicModel.h"
#import "DataHelper.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerHelper.h"
#import "LyricModel.h"
#import "LyricHelper.h"
@interface PlayerViewController ()<PlayerHelperDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sigleNameLabel;



@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *musicHeadView;

//显示歌词的tableView
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;

//播放当前进度的时间
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
//当前是歌词的第几行
@property(nonatomic,assign)NSInteger row;

//歌词的背景图片

@property (weak, nonatomic) IBOutlet UIImageView *lyricBackgroundImageView;


//当前存放的歌曲
@property(nonatomic,strong)MusicModel *music;

//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *playBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;


@end

@implementation PlayerViewController

+(instancetype)sharePlayerVC{
    static PlayerViewController *playerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取当前的Main.storyboard
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //获取playerVC实例
        playerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"playvc"];
    });
    //返回playervc
    return playerVC;

}

//musicIndex的set方法
-(void)setMusicIndex:(NSInteger)musicIndex{
   
    _musicIndex = musicIndex;
    [self changeMusic];
}



//更换歌曲
-(void)changeMusic{
    self.music = [[DataHelper shareDataHelper] getMusicModelFronIndex:self.musicIndex];
    //歌名
    self.musicTitleLabel.text = self.music.name;
    //歌手
    self.sigleNameLabel.text = self.music.singer;
    //专辑封面
    [self.musicHeadView sd_setImageWithURL:[NSURL URLWithString:self.music.picUrl] placeholderImage:[UIImage imageNamed:@"music"]];
    //歌词背景图片
    [self.lyricBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.music.picUrl] placeholderImage:[UIImage imageNamed:@"music"]];
    self.lyricBackgroundImageView.alpha = 0.7;
    
    
    //总时长
    self.totalTimeLabel.text = [NSString stringWithFormat:@"|%02ld:%02ld",self.music.duration.integerValue/1000/60,self.music.duration.integerValue/1000%60];
    [self.playBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.music.blurPicUrl]];
    
    //设置播放进度的slider
    ///
    self.timeSlider.minimumValue = 0;
    self.timeSlider.maximumValue = self.music.duration.integerValue/1000;
    
    
    //播放下标对应的歌曲
    [[PlayerHelper sharePlayer] playMusicWithIndex:self.musicIndex];
    
    //设置播放按钮
    [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    
    //设置歌词
    [[LyricHelper shareLyricHelper]serializeString:self.music.lyric];
    [self.lyricTableView reloadData];
}





//返回上一层
- (IBAction)didClickCancelButton:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
    
}


//上一首
- (IBAction)didClickLastMusicButton:(id)sender {
    //    self.musicIndex--  实现上一首
    if (self.musicIndex <= 0) {
        return;
    }
    self.musicIndex--;
}
//下一首
- (IBAction)didClickNextMusicBtton:(id)sender {
    if (self.musicIndex >= [DataHelper shareDataHelper].count-1) {
        return;
    }
    self.musicIndex++;
    
}

//播放暂停
- (IBAction)didClickPlayPauseButton:(id)sender {
    UIButton *button = sender;
//    if ([button.titleLabel.text isEqualToString:@"播放"]) {
//        [[PlayerHelper sharePlayer] play];
//        [button setTitle:@"暂停" forState:UIControlStateNormal];
//    }else{
//        [[PlayerHelper sharePlayer] pause];
//        [button setTitle:@"播放" forState:UIControlStateNormal];
//    }
    UIImage *image = [UIImage imageNamed:@"start.png"];
    if ([button.imageView.image isEqual:image] ) {
        [[PlayerHelper sharePlayer] play];
        [button setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }else{
        [[PlayerHelper sharePlayer] pause];
        [button setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    }
}
//音量大小

- (IBAction)didChangeVolumeSlider:(UISlider *)sender {
    [PlayerHelper sharePlayer].volume = sender.value;
}

//播放进度
- (IBAction)didChangeTimeSlider:(UISlider *)sender {
    //更改播放进度
    [[PlayerHelper sharePlayer] seekToTime:sender.value];
}



//高内聚低耦合
//高内聚：一个方法实现一个功能（不超十原则）
//低耦合：减少两者之间的联系，比如传递值（picUrl，singer，title  和只传一个model  即传model为低耦合）
-(void)rotate{
    [UIView animateWithDuration:0.1 animations:^{
        self.musicHeadView.transform = CGAffineTransformRotate(self.musicHeadView.transform, M_PI_4*0.01);
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.musicHeadView.layer.masksToBounds = YES;
    self.musicHeadView.layer.cornerRadius = self.view.frame.size.width*0.5;
    //指定代理
    [PlayerHelper sharePlayer].delegate = self;
    
    self.lyricTableView.dataSource = self;
    self.lyricTableView.delegate = self;
    
    // Do any additional setup after loading the view.
}

#pragma mark - PlayerHelperDelegate
//播放
-(void)playerDidPlay:(float)time{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    //设置当前时间label
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)time/60,(NSInteger)time%60];
    //设置timeSlider.value
    self.timeSlider.value = time;
    //旋转动画
    [self rotate];
    
    //歌词对应显示
    if ([LyricHelper shareLyricHelper].count > 0) {
        //获取时间对应行
        NSInteger row = [[LyricHelper shareLyricHelper]indexWithTime:time];
        //此行的indexPath
        NSLog(@"%ld",row);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        //使歌词tableView滚动到那一行
        [self.lyricTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        self.row = row;
        [self.lyricTableView reloadData];
    }
}


//停止
-(void)playerDidFinish{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    //下一首
    self.musicIndex ++;
}


#pragma mark --- UITableViewDataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricHelper shareLyricHelper].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    

  
                              
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID
                ];
    }
    
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [[LyricHelper shareLyricHelper] stringWithIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    self.lyricTableView.backgroundColor = [UIColor clearColor];

    self.lyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (indexPath.row == self.row ) {
        cell.textLabel.textColor = [UIColor greenColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    }else{
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
    
    
    
    
    
    
    return  cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
