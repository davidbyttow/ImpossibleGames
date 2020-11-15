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

class GameModel : ObservableObject {
  static let baseUrl = "https://davidbyttow.com/impossiblegames/assetbundles/"
  
  @Published var level = LevelData()
  @Published var levelCompleted = false
}
