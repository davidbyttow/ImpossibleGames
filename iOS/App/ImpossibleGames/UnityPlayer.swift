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
  private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  private var prevWindow: UIWindow!
  private var gameModel: GameModel!
  private var starting = false;

  enum GameMode {
    case none
    case inLauncher
    case inGame
  }
  
  private var unityRunning = false
  private var gameMode = GameMode.none
  private var visible = false
  
  init(withLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?, gameModel: GameModel) {
    super.init()
    self.gameModel = gameModel
    self.launchOptions = launchOptions
    unity = UnityPlayer.loadFramework()
    unity.setDataBundleId("com.unity3d.framework")
    unity.register(self)
    UnityAPIBridge.registerAPIforNativeCalls(self)
  }
  
  private func run() {
    if !unityRunning {
      unity.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)

      unity.appController().quitHandler = {
        print("QUIT HANDLER")
      }
      
      unityRunning = true
    }
  }

  func start(_ window: UIWindow, level: LevelData) {
    run()

    prevWindow = window;
    
    let appController = unity.appController()!
    appController.window.windowScene = window.windowScene!
    appController.window.makeKeyAndVisible()

    visible = true
    starting = true;
    
    if (gameMode == .inLauncher) {
      loadLevel()
    }
  }
  
  private func hide() {
    prevWindow?.makeKeyAndVisible();
    
    let appController = unity.appController()!
    appController.window.windowScene = nil

    visible = false
  }
  
  func unityOnLauncherStarted() {
    gameMode = .inLauncher
    if (starting) {
      loadLevel()
    } else {
      hide()
    }
  }
  
  func unityOnGameStarted() {
    gameMode = .inGame
  }
  
  private func loadLevel() {
    let bundleUrls = encodeBundles(sceneUrl: gameModel.level.scene, dependencyUrls: gameModel.level.deps)
    unity.sendMessageToGO(withName: "SceneLauncher", functionName: "LaunchGame", message: bundleUrls)
  }
  
  func unityLeaveGame() {
    starting = false
    unity.sendMessageToGO(withName: "GameManager", functionName: "LoadLauncher", message: "")
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

  private func unityDidUnload(notification: NSNotification) {
    print("DID UNLOAD")
  }

  private func unityDidQuit(notification: NSNotification) {
    print("DID QUIT")
  }

  private func encodeBundles(sceneUrl: String, dependencyUrls: [String]) -> String {
    var urls = dependencyUrls
    urls.append(sceneUrl)
    for i in 0...urls.count - 1 {
      urls[i] = GameModel.baseUrl + urls[i]
    }
    return urls.joined(separator: ";")
  }
}
