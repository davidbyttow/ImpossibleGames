#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"

@implementation FrameworkLibAPI

id<NativeCallsProtocol> gApi = NULL;

+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>)api {
  gApi = api;
}
@end

extern "C" {
  char* toCString(const NSString* str) {
    if (str == NULL) {
      return NULL;
    }
    const char* strUtf8 = [str UTF8String];

    char* cString = (char*)malloc(strlen(strUtf8) + 1);
    strcpy(cString, strUtf8);
    return cString;
  }

  void hostOnLauncherStarted() {
    return [gApi unityOnLauncherStarted];
  }
  void hostOnGameStarted() {
    return [gApi unityOnGameStarted];
  }
  void hostLeaveGame() {
    return [gApi unityLeaveGame];
  }
  void hostWinGame() {
    return [gApi unityWinGame];
  }
  void hostCallMethod(const char *method, const char *messageJson) {
    NSString *methodName = [[NSString alloc] initWithCString:method encoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithCString:messageJson encoding:NSUTF8StringEncoding];
    return [gApi unityInvokeMethod:methodName withMessage:jsonString];
  }
}
