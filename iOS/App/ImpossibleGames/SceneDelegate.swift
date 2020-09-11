//
//  SceneDelegate.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var windowScene: UIWindowScene?
  var unityPlayer: UnityPlayer?
    
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    windowScene = scene as? UIWindowScene
    
    unityPlayer = UnityPlayer(withLaunchOptions: AppDelegate.appLaunchOptions)

    // Attach content view to unity window view
//    let contentView = ContentView()
//    let childView = UIHostingController(rootView: contentView)
//    let unityViewController = unity.viewController!
//    unityViewController.addChild(childView)
//    childView.viewIfLoaded?.frame = unityViewController.view.frame
//    let view = unityViewController.viewIfLoaded
//    view?.addSubview(childView.view)
//    childView.didMove(toParent: unityViewController)
    
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      let contentView = ContentView(play: {
        self.unityPlayer!.play(windowScene)
      }).background(Color.black)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
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
    //unityPlayer!.play(windowScene!)
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}

//#if DEBUG
//struct SceneDelegate_Previews: PreviewProvider {
//  static var previews: some View {
//    /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//  }
//}
//#endif
