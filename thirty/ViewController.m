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
    [self searchBarConfiguration];
    [self fireBaseAuthenticationAndActivityView];
}

//Method to configure the searchBar
-(void)searchBarConfiguration{
    self.isSearch = FALSE;
    self.isFirstSearch= YES;
    self.filteredItems = [[NSMutableArray alloc]init];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.dataTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
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

//backup method to initialize table view
-(void) fireBaseAuthenticationAndActivityView {
    self.count = 10;
    self.mainUrl = @"ZlPRefDSrhk";
    self.dataArray = [NSArray arrayWithObjects:@"ZlPRefDSrhk",@"ZlPRefDSrhk",@"ZlPRefDSrhk", nil];
    self.displayItems = self.dataArray;
    }

//Method which gets triggered whenever there is a text input in the searchBar
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    [self.filteredItems removeAllObjects];
    if (![searchString isEqualToString:@""]) {
        self.isSearch = TRUE;
        NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchString];
        NSArray *filarr = [self.allUrls filteredArrayUsingPredicate:resultPredicate];
        NSLog(@"predicate data %@",filarr);
        NSMutableArray *displayTags = [[NSMutableArray alloc]init];
        NSMutableArray *ifUrlEnteredOrNot = [[NSMutableArray alloc]initWithCapacity:self.dataArray.count];
        for (int i=0; i<self.dataArray.count; i++) {
            [ifUrlEnteredOrNot insertObject:[NSNumber numberWithBool:NO] atIndex:i];
        }
        for (id eachElement in filarr) {
            NSLog(@"url adding object data %@",[self.urlDictionaryWithTag allKeysForObject:eachElement]);
            int value =[self.tagToUrlDictionary[eachElement] intValue];
                if (![[ifUrlEnteredOrNot objectAtIndex:value]boolValue]) {
                    [ifUrlEnteredOrNot insertObject:[NSNumber numberWithBool:YES] atIndex:value];
                    [displayTags addObject:self.dataArray[value]];
                }
             }
        self.displayItems = displayTags;
        [self.dataTableView reloadData];
    }
    else{
        self.displayItems = self.dataArray;
        self.isSearch = FALSE;
        if (self.isFirstSearch) {
            self.isFirstSearch = NO;
        }
        else{
          [self.dataTableView reloadData];
        }
        
    }
   
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [[event allTouches]anyObject];
    if ([self.searchController.searchBar isFirstResponder] && [touch view] != self.searchController.searchBar) {
        [self.searchController.searchBar endEditing:true];
    }
    [super touchesBegan:touches withEvent:event];
}

//Number of sections in the view - one for main video and the remaining rows for other rows.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return 1;
    }
    else{
        return 2;
    }
}

//Number of rows in each sections. One row in first section as its large. Multiple rows in the second section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isSearch) {
        if (section == 0) {
            return 1;
        }
    }
    return [self.displayItems count];
}

//cell description for each cell in both first section and the second. Different custom cells are designed for each cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isSearch) {
    if (indexPath.section == 0) {
        FirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell" ];
        if (firstCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"myFirstCell"];
            firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell"];
        }
        [firstCell.firstCellView loadWithVideoId:self.mainUrl];
        return firstCell;
    }
    }
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil)
        {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        }
    [cell.playerView loadWithVideoId:self.displayItems[indexPath.row]];
    NSArray* data = self.urlDictionaryWithTag[self.displayItems[indexPath.row]];
    [cell.videoTitle setText: [data objectAtIndex:0]];
    [cell.videoSubtitle setText: [data objectAtIndex:1]];
    return cell;
}



//Matching storyboard height with the programatically allocated height. 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSearch) {
    if (indexPath.section == 0) {
        return 250;
        }
    }
    return 150;
}


@end
