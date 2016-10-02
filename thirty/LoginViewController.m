//
//  LoginViewController.m
//  thirty
//
//  Created by Karthik Rao on 8/15/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarController.h"

@import MediaPlayer;
@import AVKit;
@import AVFoundation;

@interface LoginViewController ()

@property AVPlayer* avplayer;
@property UIActivityIndicatorView *activityView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"in login view controller");
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self videoBackground];
//    [self.view addSubview:loginButton];
     self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center=self.view.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    [self segueToNextView];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        NSLog(@"login successful");
//
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)videoBackground {
    NSLog(@"Video background being called");
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mov"];
    self.avplayer = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.frame = self.view.frame;
    controller.player = self.avplayer;
    controller.showsPlaybackControls = NO;
    [self.avplayer play];
    self.avplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];

}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)segueToNextView{
    NSLog(@"checking for segue");
    self.myRootRef = [[Firebase alloc] initWithUrl:@"https://thirty-8fabc.firebaseio.com/"];
    [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.urlDict = snapshot.value;
        NSLog(@"inside snapshot");
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.activityView stopAnimating];
                [self performSegueWithIdentifier:@"loginToMainDisplaySegue" sender:self];
            });
        });
        } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        }];
}

//Method to connect to firebase, fetch urls and load it on table view.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"loginToMainDisplaySegue"]) {
        TabBarController *destinationViewController = segue.destinationViewController;
        destinationViewController.urlDict = self.urlDict;
        }
}


@end
