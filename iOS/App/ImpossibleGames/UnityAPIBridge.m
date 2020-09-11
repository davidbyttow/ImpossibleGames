//
//  UnityAPIBridge.m
//  ImpossibleGames
//
//  Created by David Byttow on 9/11/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

#include "Bridging-Header.h"

#import <Foundation/Foundation.h>

@implementation UnityAPIBridge
+ (void)registerAPIforNativeCalls:(id<NativeCallsProtocol>)api {
  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:api];
}
@end
