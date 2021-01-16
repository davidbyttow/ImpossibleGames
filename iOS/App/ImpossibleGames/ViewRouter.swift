//
//  ViewRouter.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/15/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import Foundation
import SwiftUI


enum Page {
  case home
  case startGame
//  case gameWon
//  case gameLost
}

class ViewRouter : ObservableObject {
  @Published var currentPage: Page = .home
}
