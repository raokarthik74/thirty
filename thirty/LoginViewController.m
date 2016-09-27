//
//  LoginViewController.m
//  thirty
//
//  Created by Karthik Rao on 8/15/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
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
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self videoBackground];
//    [self.view addSubview:loginButton];
     self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center=self.view.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
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

//Method to connect to firebase, fetch urls and load it on table view.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"loginToMainDisplaySegue"]) {
        ViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.dataTableView.hidden = YES;
        [destinationViewController.dataTableView setContentOffset:CGPointMake(0.0, destinationViewController.dataTableView.tableHeaderView.frame.size.height) animated:YES];
        destinationViewController.myRootRef = [[Firebase alloc] initWithUrl:@"https://thirty-8fabc.firebaseio.com/"];
        [destinationViewController.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *urlDict = snapshot.value;
            destinationViewController.mainUrl = urlDict[@"firsturl"];
            destinationViewController.urlDictionaryWithTag = urlDict[@"urlAndTags"];
            NSArray *listOfUrls = [destinationViewController.urlDictionaryWithTag allKeys];
            destinationViewController.allUrls = [[NSMutableArray alloc] init];
            destinationViewController.tagToUrlDictionary = [[NSMutableDictionary alloc]init];
            for(int i=0; i<listOfUrls.count; i++){
                NSArray* individualDataArray = destinationViewController.urlDictionaryWithTag[listOfUrls[i]];
                for (int j=0; j<individualDataArray.count; j++) {
                    if (j == individualDataArray.count-1) {
                        [destinationViewController.locationData addObject:individualDataArray[j]];
                    }
                    else{
                        [destinationViewController.tagToUrlDictionary setValue:[NSNumber numberWithInt:i] forKey:individualDataArray[j]];
                        [destinationViewController.allUrls addObject:individualDataArray[j]];
                    }
                }
            }
            destinationViewController.dataArray = listOfUrls;
            destinationViewController.displayItems = destinationViewController.dataArray;
            destinationViewController.count = [destinationViewController.dataArray count];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    destinationViewController.dataTableView.hidden=NO;
                    [destinationViewController.dataTableView reloadData];
                    [self.activityView stopAnimating];
                    [self performSegueWithIdentifier:@"loginToMainDisplaySegue" sender:self];
                });
            });
        }];
    }
}


@end
