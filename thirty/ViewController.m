//
//  ViewController.m
//  myTable
//
//  Created by Karthik Rao on 7/9/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

CLLocationManager *locationManager;
CLGeocoder *geoCoder;
CLPlacemark *placeMark;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationCollector];
    [self fireBaseAuthenticationAndActivityView];
}

//Method to collect location to analyze for recommendations
-(void)locationCollector {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
}

//Method to connect to firebase, fetch urls and load it on table view.
-(void) fireBaseAuthenticationAndActivityView {
    self.count = 10;
    self.mainUrl = @"ZlPRefDSrhk";
    self.dataArray = [NSArray arrayWithObjects:@"ZlPRefDSrhk",@"ZlPRefDSrhk",@"ZlPRefDSrhk", nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    self.dataTableView.hidden = YES;
    self.myRootRef = [[Firebase alloc] initWithUrl:@"https://thirty-8fabc.firebaseio.com/"];
    [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *urlDict = snapshot.value;
        self.mainUrl = urlDict[@"firsturl"];
        NSString *myString = urlDict[@"urls"];
        self.dataArray = [myString componentsSeparatedByString:@","];
        self.count = [self.dataArray count];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.dataTableView.hidden=NO;
                [self.dataTableView reloadData];
                [activityView stopAnimating];
            });
        });
    }];
}

//method to fetch current location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"last latitude %f", currentLocation.coordinate.latitude);
    NSLog(@"last longitude %f", currentLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Number of sections in the view - one for main video and the remaining rows for other rows.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//Number of rows in each sections. One row in first section as its large. Multiple rows in the second section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return self.count;
    }
}

//cell description for each cell in both first section and the second. Different custom cells are designed for each cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell" ];
        if (firstCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"myFirstCell"];
            firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell"];
        }
        [firstCell.firstCellView loadWithVideoId:self.mainUrl];
        return firstCell;

    }
    else {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
        [cell.playerView loadWithVideoId:self.dataArray[indexPath.row]];
        return cell;
    }
}

//Matching storyboard height with the programatically allocated height. 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 250;
    }
    else{
        return 150;
    }
    
}


@end
