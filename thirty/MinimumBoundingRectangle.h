//
//  MinimumBoundingRectangle.h
//  thirty
//
//  Created by Karthik Rao on 9/29/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinimumBoundingRectangle : NSObject

@property double LatUp;
@property double LongRight;
@property double LatDown;
@property double LongLeft;
@property MinimumBoundingRectangle* child1;
@property MinimumBoundingRectangle* child2;
@property MinimumBoundingRectangle* child3;
- (id)initWithLatUp:(double)LatUp LongRight:(double)LongRight LatDown:(double)LatDown LongLeft:(double)LongLeft child1:(MinimumBoundingRectangle*)child1 child2:(MinimumBoundingRectangle*)child2 child3:(MinimumBoundingRectangle*)child3;

@end
