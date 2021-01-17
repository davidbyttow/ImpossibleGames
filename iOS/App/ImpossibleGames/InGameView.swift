//
//  LevelCompletedView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/15/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct LevelCompletedView: View {
  
  @ObservedObject var styles = Styles.shared
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  @Binding var state: GameState
  
  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      VStack(alignment: .center) {
        Spacer()
        Text(state == .won ? "YOU WIN" : "YOU LOST")
          .foregroundColor(styles.green)
          .font(.custom("PressStart2P-Regular", size: 48))
          .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
        Spacer()
        Button(action: { self.state = .none }) {
          Text("Back")
            .foregroundColor(styles.darkRed)
            .font(.custom("PressStart2P-Regular", size: 36))
        }
        Spacer()
      }.frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity
      )
    }.navigationBarHidden(true)
  }
}

#if DEBUG
struct LevelCompletedView_Previews: PreviewProvider {
  static var previews: some View {
    LevelCompletedView(state: Binding.constant(.won))
  }
}
#endif

