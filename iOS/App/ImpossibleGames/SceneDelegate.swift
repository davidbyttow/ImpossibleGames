//
//  SceneDelegate.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import UIKit
import SwiftUI
import UnityFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  var unity: EmbeddedUnity!

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    unity = EmbeddedUnity()
    unity.run(CommandLine.argc, argv:CommandLine.unsafeArgv)
    window = unity.window
    
//    let contentView = ContentView()
//    let childView = UIHostingController(rootView: contentView)
//    let unityViewController = unity.viewController!
//    unityViewController.addChild(childView)
//    childView.viewIfLoaded?.frame = unityViewController.view.frame
//    let view = unityViewController.viewIfLoaded
//    view?.addSubview(childView.view)
//    childView.didMove(toParent: unityViewController)

    if let windowScene = scene as? UIWindowScene {
      window?.windowScene = windowScene
      window?.makeKeyAndVisible()
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    self.unity.didBecomeActive()
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    self.unity.willResignActive()
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    self.unity.willEnterForeground()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    self.unity.didEnterBackground()
  }
}


//struct SceneDelegate_Previews: PreviewProvider {
//  static var previews: some View {
//    /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//  }
//}

struct SceneDelegate_Previews: PreviewProvider {
  static var previews: some View {
    /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
  }
}