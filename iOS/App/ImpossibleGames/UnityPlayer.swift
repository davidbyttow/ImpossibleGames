//
//  UnityPlayer.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/10/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import Foundation
import UnityFramework

class UnityPlayer : UIResponder, UnityFrameworkListener, NativeCallsProtocol {
  private var unity: UnityFramework!
  private var started = false
  private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  
  init(withLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    super.init()
    self.launchOptions = launchOptions
    unity = UnityPlayer.loadFramework()
    unity.setDataBundleId("com.unity3d.framework")
    unity.register(self)
    if let cls = NSClassFromString("FrameworkLibAPI") as? FrameworkLibAPI {
    }
    //FrameworkLibAPI.registerAPIforNativeCalls(self)
  }
  
  func play(_ windowScene: UIWindowScene) {
    start()

    if let window = unity.appController().window {
      window.windowScene = windowScene
      window.makeKeyAndVisible()
    }

    unity.showUnityWindow()
  }
  
  func unityLeaveGame() {
    print("ON LEAVE GAME");
  }
  
  func stop() {
    unity.unloadApplication()
  }
    
  private func start() {
    if !started {
      unity.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)
      started = true
    }
  }
  
  private static func loadFramework() -> UnityFramework? {
    var unityFramework: UnityFramework?
    
    var bundlePath = Bundle.main.bundlePath
    bundlePath.append("/Frameworks/UnityFramework.framework");
    
    if let bundle = Bundle(path: bundlePath) {
      if !bundle.isLoaded {
        bundle.load()
      }

      unityFramework = bundle.principalClass?.getInstance()
      if unityFramework?.appController() == nil {
        let mh = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
        mh.pointee = _mh_execute_header
        unityFramework!.setExecuteHeader(mh)
      }
    }
    
    return unityFramework
  }
}
