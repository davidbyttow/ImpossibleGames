
#import <UnityFramework/UnityFramework.h>
#import <UnityFramework/NativeCallProxy.h>

@interface UnityAPIBridge : NSObject
+ (void)registerAPIforNativeCalls:(id<NativeCallsProtocol>)aApi;
@end
