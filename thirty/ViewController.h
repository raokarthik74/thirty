//
//  ViewController.h
//  myTable
//
//  Created by Karthik Rao on 7/9/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "FirstCell.h"
#import <Firebase/Firebase.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString * mainUrl;
@property Firebase *myRootRef;
@property NSArray *dataArray;
@property NSUInteger count;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end
