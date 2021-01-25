//
//  GameModel.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/15/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct LevelData : Decodable {
  init() {}
  var title: String = ""
  var scene: String = ""
  var thumbnailUrls: [String] = []
  var deps: [String] = []
}

enum GameType {
  case recent
  case tutorial
}

enum GameState {
  case none
  case lost
  case won
}

class GameModel : ObservableObject {
  static let baseApiUrl = "https://impossible-arcade.vercel.app/api"
  static let baseAssetBundlesUrl = "https://impossible-arcade.vercel.app/static/assets/bundles"
  
  @Published var level = LevelData()
  @Published var state: GameState = .none
}
