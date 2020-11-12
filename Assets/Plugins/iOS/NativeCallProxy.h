// [!] important set UnityFramework in Target Membership for this file
// [!]           and set Public header visibility

#import <Foundation/Foundation.h>

@protocol NativeCallsProtocol
@required
- (void)unityOnLauncherStarted;
- (void)unityOnGameStarted;
- (void)unityLeaveGame;
- (NSString *)unityGetRequestedScene;
@end

__attribute__((visibility("default")))
@interface FrameworkLibAPI : NSObject
// call it any time after UnityFrameworkLoad to set object implementing NativeCallsProtocol methods
+ (void)registerAPIforNativeCalls:(id<NativeCallsProtocol>)api;
@end
