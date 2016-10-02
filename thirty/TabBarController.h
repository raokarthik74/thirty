//
//  TabBarController.h
//  thirty
//
//  Created by Karthik Rao on 9/26/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TabBarController : UITabBarController

@property NSDictionary* urlDict;
@property NSMutableDictionary* tagToUrlAndPointDictionary ;
@property CLLocation* currentLocation;
@property NSMutableDictionary *urlDictionaryWithTag;

@end
