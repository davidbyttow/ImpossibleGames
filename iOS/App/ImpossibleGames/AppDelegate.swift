//
//  AppDelegate.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
  static var appLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    AppDelegate.appLaunchOptions = launchOptions
    printAvailableFonts()
    return true
  }
    
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }

  private func printAvailableFonts() {
    for fontFamily in UIFont.familyNames.sorted() {
      let names = UIFont.fontNames(forFamilyName: fontFamily).sorted()
      print("\(fontFamily): \(names)")
    }
  }
}

