//
//  AppView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/14/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

protocol GameDelegate {
  func gameDidRequestStart(gameType: GameType)
}

struct FakeGameDelegate: GameDelegate {
  func gameDidRequestStart(gameType: GameType) {}
}

struct ContentView: View {

  @EnvironmentObject var router: ViewRouter
  @EnvironmentObject var model: GameModel
  var delegate: GameDelegate

  var body: some View {
    switch router.currentPage {
      case .home:
        HomeView(delegate: delegate)
      case .startGame:
        LevelStartView(onStartGame: { delegate.gameDidRequestStart(gameType: .recent) },
                       levelData: $model.level,
                       gameState: $model.state)
    }
  }
}
