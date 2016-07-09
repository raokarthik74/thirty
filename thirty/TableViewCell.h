//
//  TableViewCell.h
//  myTable
//
//  Created by Karthik Rao on 7/8/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface TableViewCell : UITableViewCell

@property(nonatomic, strong)IBOutlet YTPlayerView *playerView;

@end
