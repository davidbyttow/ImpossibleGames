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

int gArgc = 0;
char** gArgv = nullptr;
NSDictionary* gAppLaunchOptions;

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
  
  auto view = [self.unity.appController rootView];
//  self.viewController = [[[self unity] appController] rootView]
//  auto rootView = self.unity.appController.rootView;
  self.viewController = self.unity.appController.rootViewController;

  [self.unity showUnityWindow];

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

@end

//@interface AppDelegate : UIResponder<UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol>
//
//@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) UIButton *showUnityOffButton;
//@property (nonatomic, strong) UIButton *btnSendMsg;
//@property (nonatomic, strong) UINavigationController *navVC;
//@property (nonatomic, strong) UIButton *unloadBtn;
//@property (nonatomic, strong) UIButton *quitBtn;
//@property (nonatomic, strong) AppViewController *viewController;
//
//
//@property UnityFramework* ufw;
//@property bool didQuit;
//
//- (void)initUnity;
//- (void)ShowMainView;
//
//- (void)didFinishLaunching:(NSNotification*)notification;
//- (void)didBecomeActive:(NSNotification*)notification;
//- (void)willResignActive:(NSNotification*)notification;
//- (void)didEnterBackground:(NSNotification*)notification;
//- (void)willEnterForeground:(NSNotification*)notification;
//- (void)willTerminate:(NSNotification*)notification;
//- (void)unityDidUnloaded:(NSNotification*)notification;
//
//@end

//AppDelegate* hostDelegate = NULL;


// -------------------------------
// -------------------------------
// -------------------------------

@interface AppViewController ()
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *unloadButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *quitButton;

@property UnityFramework* unity;
@end

@implementation AppViewController

- (void)applicationWillResignActive:(UIApplication *)application { [[[self unity] appController] applicationWillResignActive: application]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self unity] appController] applicationDidEnterBackground: application]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self unity] appController] applicationWillEnterForeground: application]; }
- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self unity] appController] applicationDidBecomeActive: application]; }
- (void)applicationWillTerminate:(UIApplication *)application { [[[self unity] appController] applicationWillTerminate: application]; }

- (void)init:(int)argc argv:(char**)argv
{
  gArgc = argc;
  gArgv = argv;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blueColor];
  
  self.loadButton = [UIButton buttonWithType: UIButtonTypeSystem];
  [self.loadButton setTitle: @"Init" forState: UIControlStateNormal];
  self.loadButton.frame = CGRectMake(0, 0, 100, 44);
  self.loadButton.center = CGPointMake(50, 120);
  self.loadButton.backgroundColor = [UIColor greenColor];
  [self.loadButton addTarget: self action: @selector(initUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
  [self.view addSubview: self.loadButton];
  
  self.showButton = [UIButton buttonWithType: UIButtonTypeSystem];
  [self.showButton setTitle: @"Show Unity" forState: UIControlStateNormal];
  self.showButton.frame = CGRectMake(100, 0, 100, 44);
  self.showButton.center = CGPointMake(150, 120);
  self.showButton.backgroundColor = [UIColor lightGrayColor];
  [self.showButton addTarget: self action: @selector(showMainView) forControlEvents: UIControlEventPrimaryActionTriggered];
  [self.view addSubview: self.showButton];
  
  self.unloadButton = [UIButton buttonWithType: UIButtonTypeSystem];
  [self.unloadButton setTitle: @"Unload" forState: UIControlStateNormal];
  self.unloadButton.frame = CGRectMake(200, 0, 100, 44);
  self.unloadButton.center = CGPointMake(250, 120);
  self.unloadButton.backgroundColor = [UIColor redColor];
  [self.unloadButton addTarget: self action: @selector(unloadButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
  [self.view addSubview: self.unloadButton];

  self.quitButton = [UIButton buttonWithType: UIButtonTypeSystem];
  [self.quitButton setTitle: @"Quit" forState: UIControlStateNormal];
  self.quitButton.frame = CGRectMake(300, 0, 100, 44);
  self.quitButton.center = CGPointMake(250, 170);
  self.quitButton.backgroundColor = [UIColor redColor];
  [self.quitButton addTarget: self action: @selector(quitButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
  [self.view addSubview: self.quitButton];
}

+ (AppViewController*)application:(UIApplication *)application argc:(int)argc argv:(char**)argv didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  gArgc = argc;
  gArgv = argv;
  gAppLaunchOptions = launchOptions;
  auto viewController = [[AppViewController alloc] init];
  return viewController;
}

- (bool)isUnityInitialized
{
  return [self unity] && [[self unity] appController];
}

- (void)showMainView
{
  if(![self isUnityInitialized]) {
    showAlert(@"Unity is not initialized", @"Initialize Unity first");
  } else {
    [[self unity] showUnityWindow];
  }
}

- (void)showHostMainWindow
{
  [self showHostMainWindow:@""];
}

- (void)showHostMainWindow:(NSString*)color
{
  if ([color isEqualToString:@"blue"]) self.showButton.backgroundColor = UIColor.blueColor;
  else if ([color isEqualToString:@"red"]) self.showButton.backgroundColor = UIColor.redColor;
  else if ([color isEqualToString:@"yellow"]) self.showButton.backgroundColor = UIColor.yellowColor;
  //[self.window makeKeyAndVisible];
}

- (void)sendMsgToUnity
{
//  [[self unity] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: "yellow"];
}

- (void)initUnity
{
  if ([self isUnityInitialized]) {
    showAlert(@"Unity already initialized", @"Unload Unity first");
    return;
  }
//  if ([self didQuit]) {
//    showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
//    return;
//  }
    
  [self setUnity: loadUnityFramework()];

  // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
  // ODR is not supported in this case, (if you need embedded and ODR you need to copy data)
//  [[self unity] setDataBundleId: "com.unity3d.framework"];

//   TODO
//  [[self unity] registerFrameworkListener: self];
//  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
  
  [[self unity] runEmbeddedWithArgc:gArgc argv:gArgv appLaunchOpts: gAppLaunchOptions];
  
  // set quit handler to change default behavior of exit app
  [[self unity] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
  
//  auto view = [[[self ufw] appController] rootView];
//
//  if(self.showUnityOffButton == nil) {
//    self.showUnityOffButton = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.showUnityOffButton setTitle: @"Show Main" forState: UIControlStateNormal];
//    self.showUnityOffButton.frame = CGRectMake(0, 0, 100, 44);
//    self.showUnityOffButton.center = CGPointMake(50, 300);
//    self.showUnityOffButton.backgroundColor = [UIColor greenColor];
//    [view addSubview: self.showUnityOffButton];
//    [self.showUnityOffButton addTarget: self action: @selector(showHostMainWindow) forControlEvents: UIControlEventPrimaryActionTriggered];
//
//    self.btnSendMsg = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.btnSendMsg setTitle: @"Send Msg" forState: UIControlStateNormal];
//    self.btnSendMsg.frame = CGRectMake(0, 0, 100, 44);
//    self.btnSendMsg.center = CGPointMake(150, 300);
//    self.btnSendMsg.backgroundColor = [UIColor yellowColor];
//    [view addSubview: self.btnSendMsg];
//    [self.btnSendMsg addTarget: self action: @selector(sendMsgToUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
//
//    // Unload
//    self.unloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.unloadBtn setTitle: @"Unload" forState: UIControlStateNormal];
//    self.unloadBtn.frame = CGRectMake(250, 0, 100, 44);
//    self.unloadBtn.center = CGPointMake(250, 300);
//    self.unloadBtn.backgroundColor = [UIColor redColor];
//    [self.unloadBtn addTarget: self action: @selector(unloadButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
//    [view addSubview: self.unloadBtn];
//
//    // Quit
//    self.quitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.quitBtn setTitle: @"Quit" forState: UIControlStateNormal];
//    self.quitBtn.frame = CGRectMake(250, 0, 100, 44);
//    self.quitBtn.center = CGPointMake(250, 350);
//    self.quitBtn.backgroundColor = [UIColor redColor];
//    [self.quitBtn addTarget: self action: @selector(quitButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
//    [view addSubview: self.quitBtn];
//  }
}

- (void)unloadButtonTouched:(UIButton *)sender
{
  if (![self isUnityInitialized]) {
    showAlert(@"Unity is not initialized", @"Initialize Unity first");
  } else {
    [loadUnityFramework() unloadApplication];
  }
}

- (void)quitButtonTouched:(UIButton *)sender
{
  if (![self isUnityInitialized]) {
    showAlert(@"Unity is not initialized", @"Initialize Unity first");
  } else {
    [loadUnityFramework() quitApplication:0];
  }
}

@end


// keep arg for unity init from non main
//int gArgc = 0;
//char** gArgv = nullptr;
//NSDictionary* appLaunchOpts;


//@implementation AppDelegate
//
//- (bool)unityIsInitialized { return [self ufw] && [[self ufw] appController]; }
//
//- (void)ShowMainView
//{
//  if(![self unityIsInitialized]) {
//    showAlert(@"Unity is not initialized", @"Initialize Unity first");
//  } else {
//    [[self ufw] showUnityWindow];
//  }
//}
//
//- (void)showHostMainWindow
//{
//  [self showHostMainWindow:@""];
//}
//
//- (void)showHostMainWindow:(NSString*)color
//{
//  if([color isEqualToString:@"blue"]) self.viewController.unpauseBtn.backgroundColor = UIColor.blueColor;
//  else if([color isEqualToString:@"red"]) self.viewController.unpauseBtn.backgroundColor = UIColor.redColor;
//  else if([color isEqualToString:@"yellow"]) self.viewController.unpauseBtn.backgroundColor = UIColor.yellowColor;
//  [self.window makeKeyAndVisible];
//}
//
//- (void)sendMsgToUnity
//{
//  [[self ufw] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: "yellow"];
//}
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//  hostDelegate = self;
//  appLaunchOpts = launchOptions;
//
//  self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
//  self.window.backgroundColor = [UIColor redColor];
//  //ViewController *viewcontroller = [[ViewController alloc] initWithNibName:nil Bundle:nil];
//  self.viewController = [[AppViewController alloc] init];
//  self.navVC = [[UINavigationController alloc] initWithRootViewController: self.viewController];
//  self.window.rootViewController = self.navVC;
//  [self.window makeKeyAndVisible];
//
//  return YES;
//}
//
//- (void)initUnity
//{
//  if ([self unityIsInitialized]) {
//    showAlert(@"Unity already initialized", @"Unload Unity first");
//    return;
//  }
//  if ([self didQuit]) {
//    showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
//    return;
//  }
//
//  [self setUfw: UnityFrameworkLoad()];
//  // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
//  // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
//  [[self ufw] setDataBundleId: "com.unity3d.framework"];
//  [[self ufw] registerFrameworkListener: self];
//  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
//
//  [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
//
//  // set quit handler to change default behavior of exit app
//  [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
//
//  auto view = [[[self ufw] appController] rootView];
//
//  if(self.showUnityOffButton == nil) {
//    self.showUnityOffButton = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.showUnityOffButton setTitle: @"Show Main" forState: UIControlStateNormal];
//    self.showUnityOffButton.frame = CGRectMake(0, 0, 100, 44);
//    self.showUnityOffButton.center = CGPointMake(50, 300);
//    self.showUnityOffButton.backgroundColor = [UIColor greenColor];
//    [view addSubview: self.showUnityOffButton];
//    [self.showUnityOffButton addTarget: self action: @selector(showHostMainWindow) forControlEvents: UIControlEventPrimaryActionTriggered];
//
//    self.btnSendMsg = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.btnSendMsg setTitle: @"Send Msg" forState: UIControlStateNormal];
//    self.btnSendMsg.frame = CGRectMake(0, 0, 100, 44);
//    self.btnSendMsg.center = CGPointMake(150, 300);
//    self.btnSendMsg.backgroundColor = [UIColor yellowColor];
//    [view addSubview: self.btnSendMsg];
//    [self.btnSendMsg addTarget: self action: @selector(sendMsgToUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
//
//    // Unload
//    self.unloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.unloadBtn setTitle: @"Unload" forState: UIControlStateNormal];
//    self.unloadBtn.frame = CGRectMake(250, 0, 100, 44);
//    self.unloadBtn.center = CGPointMake(250, 300);
//    self.unloadBtn.backgroundColor = [UIColor redColor];
//    [self.unloadBtn addTarget: self action: @selector(unloadButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
//    [view addSubview: self.unloadBtn];
//
//    // Quit
//    self.quitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.quitBtn setTitle: @"Quit" forState: UIControlStateNormal];
//    self.quitBtn.frame = CGRectMake(250, 0, 100, 44);
//    self.quitBtn.center = CGPointMake(250, 350);
//    self.quitBtn.backgroundColor = [UIColor redColor];
//    [self.quitBtn addTarget: self action: @selector(quitButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
//    [view addSubview: self.quitBtn];
//  }
//}
//
//- (void)unloadButtonTouched:(UIButton *)sender
//{
//  if(![self unityIsInitialized]) {
//    showAlert(@"Unity is not initialized", @"Initialize Unity first");
//  } else {
//    [UnityFrameworkLoad() unloadApplication];
//  }
//}
//
//- (void)quitButtonTouched:(UIButton *)sender
//{
//  if(![self unityIsInitialized]) {
//    showAlert(@"Unity is not initialized", @"Initialize Unity first");
//  } else {
//    [UnityFrameworkLoad() quitApplication:0];
//  }
//}
//
//- (void)unityDidUnload:(NSNotification*)notification
//{
//  NSLog(@"unityDidUnload called");
//
//  [[self ufw] unregisterFrameworkListener: self];
//  [self setUfw: nil];
//  [self showHostMainWindow:@""];
//}
//
//- (void)unityDidQuit:(NSNotification*)notification
//{
//  NSLog(@"unityDidQuit called");
//
//  [[self ufw] unregisterFrameworkListener: self];
//  [self setUfw: nil];
//  [self setDidQuit:true];
//  [self showHostMainWindow:@""];
//}
//
//
//- (void)applicationWillResignActive:(UIApplication *)application { [[[self ufw] appController] applicationWillResignActive: application]; }
//- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self ufw] appController] applicationDidEnterBackground: application]; }
//- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self ufw] appController] applicationWillEnterForeground: application]; }
//- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self ufw] appController] applicationDidBecomeActive: application]; }
//- (void)applicationWillTerminate:(UIApplication *)application { [[[self ufw] appController] applicationWillTerminate: application]; }
//
//@end
//
//
//int main(int argc, char* argv[])
//{
//  gArgc = argc;
//  gArgv = argv;
//
//  @autoreleasepool
//  {
//    if (false)
//    {
//      // run UnityFramework as main app
//      id ufw = UnityFrameworkLoad();
//
//      // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and call to setDataBundleId
//      // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
//      [ufw setDataBundleId: "com.unity3d.framework"];
//      [ufw runUIApplicationMainWithArgc: argc argv: argv];
//    } else {
//      // run host app first and then unity later
//      UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: "AppDelegate"]);
//    }
//  }
//
//  return 0;
//}
