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
    self.myRootRef = [[Firebase alloc] initWithUrl:@"https://thirty-8fabc.firebaseio.com/"];
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
        [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
            NSDictionary *urlDict = snapshot.value;
            NSArray *remainingURLs = urlDict[@"urls"];
            NSLog(@"urls %@", urlDict[@"urls"]);
            self.count =  [remainingURLs count];
        }];
        return self.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell" ];
        if (firstCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"myFirstCell"];
            firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell"];
        }
        [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
            NSDictionary *urlDict = snapshot.value;
            self.mainUrl = urlDict[@"firsturl"];
            NSLog(@"first url %@", self.mainUrl );
            [firstCell.firstCellView loadWithVideoId:self.mainUrl];
                    }];
        return firstCell;

    }
    else {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
        [self.myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
            NSDictionary *urlDict = snapshot.value;
            NSArray *remainingURLs = urlDict[@"urls"];
            NSLog(@"urls %@", urlDict[@"urls"]);
            [cell.playerView loadWithVideoId:remainingURLs[indexPath.row]];
        }];
    
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
