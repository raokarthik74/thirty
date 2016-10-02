//
//  MinimumBoundingRectangle.m
//  thirty
//
//  Created by Karthik Rao on 9/29/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import "MinimumBoundingRectangle.h"

@interface MinimumBoundingRectangle()

@property MinimumBoundingRectangle* root;

@end


@implementation MinimumBoundingRectangle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _LatUp = 0;
        _LongLeft = 0;
        _LongRight = 0;
        _LatDown = 0;
        _child1 = nil;
        _child2 = nil;
        _child3 = nil;

    }
    return self;
}
- (id)initWithLatUp:(double)LatUp LongRight:(double)LongRight LatDown:(double)LatDown LongLeft:(double)LongLeft child1:(MinimumBoundingRectangle*)child1 child2:(MinimumBoundingRectangle*)child2 child3:(MinimumBoundingRectangle*)child3
{
    self = [super init];
    if (self) {
        self.LatUp = LatUp;
        self.LongLeft = LongLeft;
        self.LongRight = LongRight;
        self.LatDown = LatDown;
        self.child1 = child1;
        self.child2 = child2;
        self.child3 = child3;
    }
    return self;
}

@end
