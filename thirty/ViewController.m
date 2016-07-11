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
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://thirty-8fabc.firebaseio.com/"];
    // Write data to Firebase
    [myRootRef setValue:@"Do you have data? You'll love Firebase."];
    // Read data and react to changes
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
    [self.mainPlayer loadWithVideoId:@"M7lc1UVf-VE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    [cell.playerView loadWithVideoId:@"M7lc1UVf-VE"];
    
    FirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell"];
    if (!firstCell) {
        [tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"myFirstCell"];
        firstCell = [tableView dequeueReusableCellWithIdentifier:@"myFirstCell"];
    }
    [firstCell.firstCellView loadWithVideoId:@"CcRgLoq_z3A"];
    if (indexPath.row == 0) {
        return firstCell;
    }
    else {
       return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
    else{
        return 150;
    }
    
}


@end
