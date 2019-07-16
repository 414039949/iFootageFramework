//
//  iFTutorialVideoViewController.m
//  iFootage
//
//  Created by 黄品源 on 2017/9/8.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFTutorialVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "iFButton.h"
#import "iFLabel.h"

#import "iFStatusBarView.h"


@interface iFTutorialVideoViewController ()
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;
@property (nonatomic, strong) NSArray * fileArray;
@property (nonatomic, assign) NSInteger fileIndex;

@end

@implementation iFTutorialVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.connectBtn.alpha = 0;
    self.titleLabel.text = NSLocalizedString(Tutorials, nil);
    
    _fileArray = @[@"01 Basic Setup", @"02 3 Axis Slider Setup", @"03 App Setup", @"04 App Target Control", @"05 Balance Camera", @"06 Timelapse Control", @"07 Stitching Grid", @"08 Stitching Pana"];
    _fileIndex = 0;
    for (int i = 0 ; i < _fileArray.count; i++) {
        iFButton * VideoBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, kScreenHeight * 0.15 + kScreenHeight * 0.1 * i, kScreenWidth, kScreenHeight * 0.08) andTitle:_fileArray[i]];
        VideoBtn.backgroundColor = [UIColor clearColor];
        [VideoBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        VideoBtn.tag =  100 + i;
        [self.view addSubview:VideoBtn];
        
//        [VideoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.top.mas_equalTo(kScreenHeight * 0.15 + kScreenHeight * 0.1 * i);
//            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight * 0.08));
//
//        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
//    [iFStatusBarView sharedView].alpha = 0;

}
- (void)viewWillDisappear:(BOOL)animated{
//    [iFStatusBarView sharedView].alpha = 1;

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

- (void)playVideo:(iFButton *)btn{
    self.moviePlayerViewController=nil;//保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    _fileIndex = btn.tag - 100;
    [iFStatusBarView sharedView].alpha = 0;

    //    [self presentViewController:self.moviePlayerViewController animated:YES completion:nil];
    //注意，在MPMoviePlayerViewController.h中对UIViewController扩展两个用于模态展示和关闭MPMoviePlayerViewController的方法，增加了一种下拉展示动画效果
    
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}
-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        NSURL *url=[self getFileUrl:_fileArray[_fileIndex]];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        _moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
//        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation((-M_PI_2 + M_PI));
//        _moviePlayerViewController.view.transform = landscapeTransform;
        
        _moviePlayerViewController.moviePlayer.scalingMode = MPMovieScalingModeNone;
        
        [self addNotification];
    }
    return _moviePlayerViewController;
}
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
}
/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
    [iFStatusBarView sharedView].alpha = 1;

}
#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl:(NSString *)fileName{
    
    
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

@end
