#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"

@implementation FrameworkLibAPI

id<NativeCallsProtocol> gApi = NULL;

+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>)api {
  gApi = api;
}
@end

extern "C" {
  void hostLeaveGame() {
    return [gApi unityLeaveGame];
  }
}
