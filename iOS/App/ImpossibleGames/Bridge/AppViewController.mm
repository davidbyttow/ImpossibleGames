//
//  AppViewController.m
//  ImpossibleGames
//
//  Created by David Byttow on 9/5/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

#include "AppViewController.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>

// Based on https://github.com/Unity-Technologies/uaal-example/blob/master/NativeiOSApp/NativeiOSApp/MainViewController.mm

UnityFramework* loadUnityFramework()
{
  NSString* bundlePath = nil;
  bundlePath = [[NSBundle mainBundle] bundlePath];
  bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
  
  NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
  if ([bundle isLoaded] == false) {
    [bundle load];
  }
  
  UnityFramework* unity = [bundle.principalClass getInstance];
  if (![unity appController]) {
    [unity setExecuteHeader: &_mh_execute_header];
  }
  return unity;
}

void showAlert(NSString* title, NSString* msg) {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg                                                         preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
  [alert addAction:defaultAction];
  auto delegate = [[UIApplication sharedApplication] delegate];
  [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@interface UnityDelegate : NSObject<UnityFrameworkListener, NativeCallsProtocol>
- (id)initWithUnity:(EmbeddedUnity *)unity;
@property EmbeddedUnity *unity;
@end

@implementation UnityDelegate
- (id)initWithUnity:(EmbeddedUnity *)unity {
  self = [super init];
  if (self) {
    self.unity = unity;
  }
  return self;
}

- (void)showHostMainWindow:(NSString *)color {
  NSLog(@"showHostMainWindow");
}

@end

@interface EmbeddedUnity ()
@property UnityFramework* unity;
@property UnityDelegate* delegate;
@end

@implementation EmbeddedUnity
- (void)initUnity {
  self.unity = loadUnityFramework();
}

- (void)run:(int)argc argv:(char**)argv; {
  [self initUnity];
  [self.unity setDataBundleId: "com.unity3d.framework"];

  self.delegate = [[UnityDelegate alloc] init];
  
  [self.unity registerFrameworkListener:self.delegate];
  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self.delegate];
  
  auto launchOptions = [NSMutableDictionary dictionary];
  
  [self.unity runEmbeddedWithArgc:argc argv:argv appLaunchOpts:launchOptions];
  
  self.unity.appController.quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };

  self.window = self.unity.appController.window;
  self.viewController = self.unity.appController.rootViewController;
}

- (void)didBecomeActive {
}

- (void)willResignActive {
}

- (void)willEnterForeground {
  [self.unity showUnityWindow];
}

- (void)didEnterBackground {
}

- (void)sendMsgToUnity
{
//  [[self unity] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: "yellow"];
}

@end
