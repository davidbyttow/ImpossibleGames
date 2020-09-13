//
//  Extensions.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/12/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

extension Color {
  init(red: Int, green: Int, blue: Int) {
    self.init(
      red: Double(red) / 255.0,
      green: Double(green) / 255.0,
      blue: Double(blue) / 255.0
    )
  }
}
