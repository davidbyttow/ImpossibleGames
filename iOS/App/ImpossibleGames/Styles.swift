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
      .font(.custom("PressStart2P", size: size))
  }
}

class Styles : ObservableObject {
  static let shared = Styles()
  private init() {}
  
  @Published var retro = Font.custom("PressStart2P", size: 12)
  
  @Published var darkRed = Color(red: 168, green: 0, blue: 0)
  @Published var green = Color(red: 51, green: 239, blue: 0)
  @Published var gray = Color(red: 120, green: 120, blue: 120)
}
