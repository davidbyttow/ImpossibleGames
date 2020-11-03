//
//  SceneDelegate.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GameHooks {
  
  var window: UIWindow?
  var windowScene: UIWindowScene?
  var unityPlayer: UnityPlayer?
  var levelController = LevelModelController()
    
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    windowScene = scene as? UIWindowScene
    
    unityPlayer = UnityPlayer(withLaunchOptions: AppDelegate.appLaunchOptions, gameHooks:self)

    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      
      UINavigationBar.setAnimationsEnabled(false);
      let contentView = ContentView(levelModel: levelController, play: {
        self.unityPlayer!.play(window)
      })

      window.rootViewController = UIHostingController(rootView: contentView)
      window.makeKeyAndVisible()
      self.window = window
    }
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

  func getRequestedScenes() -> String {
    let level = levelController.level
    var scenes = level.deps
    scenes.append(level.scene)
    for i in 0...scenes.count - 1 {
      scenes[i] = "https://davidbyttow.com/" + scenes[i]
    }
    let sceneString = scenes.joined(separator: ";")
    print("Sending requested scene: \(sceneString)")
    return sceneString
  }
}

//#if DEBUG
//struct SceneDelegate_Previews: PreviewProvider {
//  static var previews: some View {
//    /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//  }
//}
//#endif

    // Attach content view to unity window view
//    let contentView = ContentView()
//    let childView = UIHostingController(rootView: contentView)
//    let unityViewController = unity.viewController!
//    unityViewController.addChild(childView)
//    childView.viewIfLoaded?.frame = unityViewController.view.frame
//    let view = unityViewController.viewIfLoaded
//    view?.addSubview(childView.view)
//    childView.didMove(toParent: unityViewController)
