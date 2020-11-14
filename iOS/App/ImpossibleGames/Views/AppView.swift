//
//  AppView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/14/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

protocol GameDelegate {
  func gameDidRequestStart()
}

struct FakeGameDelegate: GameDelegate {
  func gameDidRequestStart() {}
}


struct AppView: View {

  @StateObject var model: GameModel
  var delegate: GameDelegate

  var body: some View {
    NavigationView {
      HomeView(delegate: delegate)
        .environmentObject(model)
    }
  }
}
