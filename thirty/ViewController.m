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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainUrl = @"8wF-mKMsynE";
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://thirty-8fabc.firebaseio.com/"];
        [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
            NSDictionary *urlDict = snapshot.value;
            self.mainUrl = urlDict[@"firsturl"];
            NSLog(@"first url %@", self.mainUrl );
            NSArray *remainingURLs = urlDict[@"urls"];
            NSLog(@"urls %@", urlDict[@"urls"]);
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
//        NSUInteger size = [self.remainingURLs count];
       return 12;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell" ];
        if (firstCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"myFirstCell"];
            firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell"];
        }
        NSLog(@"check");
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
    [cell.playerView loadWithVideoId:@"8wF-mKMsynE"];
        return cell;
    }
}




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
