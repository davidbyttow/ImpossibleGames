//
//  ContentView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct ComingSoonOverlay: View {
  let purple = Color(red: 125, green: 0, blue: 168)

  var body: some View {
    Text("Coming Soon")
      .foregroundColor(purple)
      .font(.custom("PressStart2P", size: 14))
  }
}

struct HomeView: View {
  
  @ObservedObject var styles = Styles.shared
  @EnvironmentObject var model: GameModel
  var delegate: GameDelegate

  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      VStack(alignment: .center) {
        Text("IMPOSSIBLE")
          .modifier(RetroText(size: 26))
          .foregroundColor(styles.darkRed)
          .padding(EdgeInsets(top: 64, leading: 0, bottom: 0, trailing: 0))
        Text("GAMES")
          .foregroundColor(.white)
          .font(.custom("PressStart2P", size: 52))
          .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
        Spacer()
        NavigationLink(destination: LevelStartView(onStartGame: { delegate.gameDidRequestStart() },
                                                   levelData: $model.level,
                                                   levelCompleted: $model.levelCompleted)) {
          Text("PLAY")
            .foregroundColor(styles.green)
            .font(.custom("PressStart2P", size: 52))
        }
        Spacer().frame(height: 40)
        Text("BUILD")
          .foregroundColor(styles.gray)
          .font(.custom("PressStart2P", size: 42))
          .frame(height: 68)
//          .overlay(ComingSoonOverlay(), alignment: .bottomTrailing)
        Spacer()
        Text("Code and Graphics")
          .foregroundColor(styles.darkRed)
          .font(.custom("PressStart2P", size: 14))
        Text("David Byttow")
          .foregroundColor(styles.gray)
          .padding(EdgeInsets(top: 6, leading: 0, bottom: 20, trailing: 0))
          .font(.custom("PressStart2P", size: 14))
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
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(delegate: FakeGameDelegate())
      .environmentObject(GameModel())
  }
}
#endif

