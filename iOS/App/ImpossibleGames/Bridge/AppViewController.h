//
//  AppViewController.h
//  ImpossibleGames
//
//  Created by David Byttow on 9/5/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

@class UIViewController;
@class UIWindow;

@interface EmbeddedUnity : NSObject
@property UIViewController *viewController;
@property UIWindow *window;

- (void)run:(int)argc argv:(char**)argv;
- (void)didBecomeActive;
- (void)willResignActive;
- (void)willEnterForeground;
- (void)didEnterBackground;
@end
