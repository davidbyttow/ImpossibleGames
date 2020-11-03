//
//  Model.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/2/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct LevelData : Decodable {
  init() {}
  var title: String = "???"
  var scene: String = ""
  var deps: [String] = []
}

class LevelModelController : ObservableObject {
  @Published var level = LevelData()
}
