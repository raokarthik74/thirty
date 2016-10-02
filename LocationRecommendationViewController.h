//
//  LocationRecommendationViewController.h
//  thirty
//
//  Created by Karthik Rao on 9/29/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MinimumBoundingRectangle.h"

@interface LocationRecommendationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *locationRecommendationTable;

@end
