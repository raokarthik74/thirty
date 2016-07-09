//
//  ViewController.h
//  myTable
//
//  Created by Karthik Rao on 7/9/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet YTPlayerView *mainPlayer;

@end
