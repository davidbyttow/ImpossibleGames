//
//  SceneDelegate.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GameDelegate {
  
  var window: UIWindow?
  var windowScene: UIWindowScene?
  var unityPlayer: UnityPlayer?
  var model = GameModel()
    
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    windowScene = scene as? UIWindowScene
    
    unityPlayer = UnityPlayer(withLaunchOptions: AppDelegate.appLaunchOptions, gameModel:model)

    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      
      UINavigationBar.setAnimationsEnabled(false);
      let contentView = AppView(model: self.model, delegate: self)

      window.rootViewController = UIHostingController(rootView: contentView)
      window.makeKeyAndVisible()
      self.window = window
    }
  }
  
  func gameDidRequestStart() {
    self.unityPlayer!.start(window!, level: model.level)
  }
      
  func sceneDidDisconnect(_ scene: UIScene) {
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
  }
}
