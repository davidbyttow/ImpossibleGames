//
//  AppViewController.h
//  ImpossibleGames
//
//  Created by David Byttow on 9/5/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

#ifndef APPVIEWCONTROLLER_H
#define APPVIEWCONTROLLER_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppViewController : UIViewController
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
@end

@interface EmbeddedUnity : NSObject
@property UIViewController *viewController;

- (void)run:(int)argc argv:(char**)argv;
- (void)didBecomeActive;
- (void)willResignActive;
- (void)willEnterForeground;
- (void)didEnterBackground;
@end

#endif
