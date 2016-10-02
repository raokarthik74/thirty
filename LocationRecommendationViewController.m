//
//  LocationRecommendationViewController.m
//  thirty
//
//  Created by Karthik Rao on 9/29/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "LocationRecommendationViewController.h"
#import "TableViewCell.h"
#import "ViewController.h"
#import "TabBarController.h"
#import <MapKit/MapKit.h>

@interface LocationRecommendationViewController ()

@property NSArray* pointArray;
@property MinimumBoundingRectangle* root;
@property CLLocation* currentLocation;
@property NSMutableDictionary* nearestNeighbourDistanceWithPointKeys;
@property NSMutableDictionary* tagToUrlAndPointDictionary;
@property NSArray* sortedListOfPoints;
@property NSMutableDictionary* urlDictionaryWithTag;

@end

@implementation LocationRecommendationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TabBarController *tabBarController = (TabBarController*)self.tabBarController;
    self.tagToUrlAndPointDictionary  = tabBarController.tagToUrlAndPointDictionary ;
    NSLog(@"tagToUrlAndPointDictionary %@", self.tagToUrlAndPointDictionary);
    self.locationRecommendationTable.delegate = self;
    self.locationRecommendationTable.dataSource = self;
    self.currentLocation = tabBarController.currentLocation;
    self.urlDictionaryWithTag = tabBarController.urlDictionaryWithTag;
    NSLog(@"all keys %@ ", [self.tagToUrlAndPointDictionary  allKeys]);
    self.pointArray = [self.tagToUrlAndPointDictionary allValues];
    NSLog(@"point array %@ ", self.pointArray);
    self.nearestNeighbourDistanceWithPointKeys = [[NSMutableDictionary alloc] init];
    for(id point in self.pointArray){
        NSLog(@"current point %@", point);
        NSLog(@"current location lattitude %f and longitude %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.latitude);
        double distance = [self.currentLocation distanceFromLocation:point];
        [self.nearestNeighbourDistanceWithPointKeys setObject:[NSNumber numberWithDouble:distance] forKey:point];
        NSLog(@"distance %f", distance);
    }
    NSLog(@"nearest Neighbours keys%@", [self.nearestNeighbourDistanceWithPointKeys allKeys]);
    NSLog(@"nearest Neighbours values%@", [self.nearestNeighbourDistanceWithPointKeys allValues]);
    self.sortedListOfPoints = [self.nearestNeighbourDistanceWithPointKeys allValues];
    NSLog(@"sorted list of points %@", self.sortedListOfPoints);
    self.sortedListOfPoints = [self.sortedListOfPoints sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"sorted list of points %@", self.sortedListOfPoints);
}

//Number of sections in the view - one for main video and the remaining rows for other rows.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Number of rows in each sections. One row in first section as its large. Multiple rows in the second section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of entries %lu", (unsigned long)[self.sortedListOfPoints count]);
    return [self.sortedListOfPoints count];
}

//cell description for each cell in both first section and the second. Different custom cells are designed for each cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    NSLog(@"number of entries %lu", (unsigned long)[self.sortedListOfPoints count]);
    NSLog(@"current row element %@", [self.sortedListOfPoints objectAtIndex:indexPath.row]);
    NSArray* allKeys = [self.nearestNeighbourDistanceWithPointKeys allKeysForObject:[self.sortedListOfPoints objectAtIndex:indexPath.row]];
    NSLog(@"number of keys %lu", (unsigned long)[allKeys count]);
    NSLog(@"key at 0 index %@", [allKeys objectAtIndex:0]);
    CLLocation *temp =[allKeys objectAtIndex:0];
    NSArray* allKeysOfURLs = [self.tagToUrlAndPointDictionary allKeysForObject:temp];
    NSLog(@"number of url keys %@", allKeysOfURLs);
    
//    NSLog(@"key at 0 url index %@", [allKeysOfURLs objectAtIndex:0]);
//    [cell.playerView loadWithVideoId:allKeysOfURLs[0]];
//    NSArray* data = self.urlDictionaryWithTag[allKeysOfURLs[0]];
//    [cell.videoTitle setText: [data objectAtIndex:0]];
//    [cell.videoSubtitle setText: [data objectAtIndex:1]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)insert:(CLLocation*)entry{
    MinimumBoundingRectangle* newEntry = [[MinimumBoundingRectangle alloc]initWithLatUp:entry.coordinate.latitude LongRight:entry.coordinate.longitude LatDown:entry.coordinate.latitude LongLeft:entry.coordinate.longitude child1:nil child2:nil child3:nil];
    MinimumBoundingRectangle* leafNode =[self chooseLeaf:newEntry];
    if (!leafNode.child1) {
        leafNode.child1 = newEntry;
    }
    else if (!leafNode.child2) {
        leafNode.child2 = newEntry;
    }
    else if (!leafNode.child3) {
        leafNode.child3 = newEntry;
    }
    else{
        [self splitNode:leafNode becauseOfNewEntry:newEntry];
        [self adjustTree];
    }
    return YES;
}

-(void)splitNode:(MinimumBoundingRectangle*)node becauseOfNewEntry:(MinimumBoundingRectangle*)newEntry{
    
}

-(void)pickSeedsOfLeafNode:(MinimumBoundingRectangle*)leafNode withNewEntry:(MinimumBoundingRectangle*)newEntry{
    double maxArea = DBL_MIN, tempArea;
    maxArea = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:leafNode.child1 withNewEntry:leafNode.child2]]-[self areaOfMinimumBoundingRectangle:leafNode.child1]-[self areaOfMinimumBoundingRectangle:leafNode.child2];
    MinimumBoundingRectangle* g1 = leafNode.child1;
    MinimumBoundingRectangle* g2 = leafNode.child2;
    MinimumBoundingRectangle* remainingNode = leafNode.child3;
    tempArea = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:leafNode.child2 withNewEntry:leafNode.child3]]-[self areaOfMinimumBoundingRectangle:leafNode.child2]-[self areaOfMinimumBoundingRectangle:leafNode.child3];
    if (tempArea > maxArea) {
        g1 = leafNode.child2;
        g2 = leafNode.child3;
        remainingNode = leafNode.child1;
    }
    tempArea = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:leafNode.child1 withNewEntry:leafNode.child3]]-[self areaOfMinimumBoundingRectangle:leafNode.child1]-[self areaOfMinimumBoundingRectangle:leafNode.child3];
    if (tempArea > maxArea) {
        g1 = leafNode.child1;
        g2 = leafNode.child3;
        remainingNode = leafNode.child1;
    }
  //  BOOL chooseNewEntry = [self PickNext:g1 withG2:g2 withNewEntry:newEntry andOldEntry:remainingNode];
    
}


-(BOOL)PickNext:(MinimumBoundingRectangle*)g1 withG2:(MinimumBoundingRectangle*)g2 withNewEntry:(MinimumBoundingRectangle*)newEntry andOldEntry:(MinimumBoundingRectangle*)oldEntry{
    double d1 = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:g1  withNewEntry:newEntry]];
    double d2 = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:g2  withNewEntry:newEntry]];
    double da = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:g1  withNewEntry:oldEntry]];
    double db = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:g2  withNewEntry:oldEntry]];
    return fabs(da-db)>fabs(d1 - d2)? NO:YES;
}

-(void)adjustTree{
    
}

-(MinimumBoundingRectangle*)chooseLeaf:(MinimumBoundingRectangle*)newEntry{
    MinimumBoundingRectangle* temp = self.root;
    double areaOne=0, areaTwo=0, areaThree=0;
    if (temp) {
        while(![self isLeaf:temp]){
            if (temp.child1) {
                areaOne = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:temp.child1 withNewEntry:newEntry]];
            }
            if (temp.child2){
                areaTwo = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:temp.child2 withNewEntry:newEntry]];
            }
            if (temp.child3) {
                areaThree = [self areaOfMinimumBoundingRectangle:[self checkMinimumBoundingRectangleBorderOf:temp.child3 withNewEntry:newEntry]];
            }
                if (areaOne < areaTwo && areaOne < areaThree) {
                    temp = temp.child1;
                }
                else if (areaTwo < areaOne && areaTwo < areaThree) {
                    temp = temp.child2;
                }
                else{
                    temp = temp.child3;
                }
        }
        return temp;
    }
    else{
        self.root = [[MinimumBoundingRectangle alloc]init];
        return self.root;
    }
}
-(BOOL)isLeaf:(MinimumBoundingRectangle*)node{
    if (![self isLeafChild:node.child1] && ![self isLeafChild:node.child2] && ![self isLeafChild:node.child3]) {
        return YES;
    }
    else{
        return NO;
    }
}
-(BOOL)isLeafChild:(MinimumBoundingRectangle*)node{
    if (!node.child1 && !node.child2 && !node.child3) {
        return YES;
    }
    else{
        return NO;
    }
}

-(MinimumBoundingRectangle*)checkMinimumBoundingRectangleBorderOf:(MinimumBoundingRectangle*)mainRectangle withNewEntry:(MinimumBoundingRectangle*)newEntry {
    MinimumBoundingRectangle* tempForArea = [[MinimumBoundingRectangle alloc]init];
    tempForArea.LatUp = MIN(mainRectangle.LatUp, newEntry.LatUp);
    tempForArea.LatDown = MIN(mainRectangle.LatDown, newEntry.LatDown);
    tempForArea.LongLeft = MIN(mainRectangle.LongLeft, newEntry.LongLeft);
    tempForArea.LongRight = MIN(mainRectangle.LongRight, newEntry.LongRight);
    return tempForArea;
}

-(double)areaOfMinimumBoundingRectangle:(MinimumBoundingRectangle*)data{
    return fabs(data.LatDown-data.LatUp) * fabs(data.LongRight-data.LongLeft);
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
