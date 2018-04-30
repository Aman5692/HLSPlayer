//
//  ViewController.m
//  HLSLocalPlayer
//
//  Created by Prabodh Prakash on 16/04/18.
//  Copyright © 2018 InMobi. All rights reserved.
//

#import "ViewController.h"
#import "HTTPServer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define WebBasePath [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"Downloads"] stringByAppendingPathComponent:@""]

#define AdBasePath [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"Ads"] stringByAppendingPathComponent:@""]

#define LocalCachingBasePath [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"TestLocalCaching"] stringByAppendingPathComponent:@""]

@interface ViewController ()

@property (nonatomic, strong) HTTPServer * mediaHttpServer;
@property (nonatomic, strong) HTTPServer * adHttpServer;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
- (IBAction)playLocallyCaller:(id)sender;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self openHttpMediaServer];
//    [self openHttpAdServer];
}

-(void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openHttpMediaServer
{
    self.mediaHttpServer = [[HTTPServer alloc] init];
    [self.mediaHttpServer setType:@"_http._tcp."];
    [self.mediaHttpServer setPort:12345];
    
    NSString *webPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]  stringByAppendingPathComponent:@"Downloads"];
    
    webPath = WebBasePath;
    
    NSLog(@"-------------\nSetting document root: %@\n", webPath);
    [self.mediaHttpServer setDocumentRoot:webPath];
    NSError *error;
    if(![self.mediaHttpServer start:&error])
    {
        NSLog(@"-------------\nError starting media HTTP Server: %@\n", error);
    }
    else {
        NSLog(@"HTTP media server setup successfully");
    }
}

- (void)openHttpAdServer
{
    self.adHttpServer = [[HTTPServer alloc] init];
    [self.adHttpServer setType:@"_http._tcp."];
    [self.adHttpServer setPort:12346];
    
    NSString *webPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]  stringByAppendingPathComponent:@"Ads"];
    
    webPath = AdBasePath;
    
    NSLog(@"-------------\nSetting document root: %@\n", webPath);
    [self.adHttpServer setDocumentRoot:webPath];
    NSError *error;
    if(![self.adHttpServer start:&error])
    {
        NSLog(@"-------------\nError starting ads HTTP Server: %@\n", error);
    }
    else {
        NSLog(@"HTTP ads server setup successfully");
    }
}

- (void)playVideoFromLocal {
    
    NSMutableString * playurl = [LocalCachingBasePath mutableCopy];//[NSString stringWithFormat:@"http://127.0.0.1:12345/segmented_file/mainvideofile.m3u8"];
    [playurl appendString:@"/mainvideofile.m3u8"];
//    NSString *localDownloadsPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Downloads"];
//    NSString *filePath = [localDownloadsPath stringByAppendingPathComponent:@"segmented_file/mainvideofile.m3u8"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    if ([fileManager fileExistsAtPath:filePath]) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString: playurl]];
        [self presentViewController:playerVC animated:YES completion:^{
            [playerVC.player play];
        }];
//    }
//    else {
//        NSLog(@"File Path %@ does not exist",filePath);
//    }
}


- (IBAction)playLocallyCaller:(id)sender {
    [self playVideoFromLocal];
}
@end
