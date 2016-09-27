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
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating>

@property NSString * mainUrl;
@property (nonatomic, strong) UISearchController * searchController;
@property Firebase *myRootRef;
@property NSArray *dataArray;
@property NSArray *titleArray;
@property NSMutableArray *allUrls;
@property NSMutableDictionary *tagToUrlDictionary;
@property NSUInteger count;
@property Boolean isFirstSearch;
@property NSMutableArray* filteredItems;
@property NSArray* displayItems;
@property BOOL isSearch;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property NSMutableDictionary *urlDictionaryWithTag;
@property NSMutableArray* locationData;

@end
