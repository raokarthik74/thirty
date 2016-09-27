//
//  LoginViewController.h
//  thirty
//
//  Created by Karthik Rao on 8/15/16.
//  Copyright © 2016 Karthik Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Firebase/Firebase.h>

@interface LoginViewController : UIViewController

@property Firebase *myRootRef;
@property NSDictionary *urlDict;

@end
