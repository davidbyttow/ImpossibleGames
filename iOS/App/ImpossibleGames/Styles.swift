//
//  Style.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/19/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct RetroText : ViewModifier {
  
  var size: CGFloat = 12
  
  func body(content: Content) -> some View {
    content
      .font(.custom("PressStart2P-Regular", size: size))
  }
}

class Styles : ObservableObject {
  static let shared = Styles()
  private init() {}
  
  @Published var retro = Font.custom("PressStart2P-Regular", size: 12)
  @Published var darkRed = Color(red: 168, green: 0, blue: 0)
  @Published var green = Color(red: 51, green: 239, blue: 0)
  @Published var gray = Color(red: 120, green: 120, blue: 120)
}

extension Color {
  init(red: Int, green: Int, blue: Int) {
    self.init(
      red: Double(red) / 255.0,
      green: Double(green) / 255.0,
      blue: Double(blue) / 255.0
    )
  }
}
