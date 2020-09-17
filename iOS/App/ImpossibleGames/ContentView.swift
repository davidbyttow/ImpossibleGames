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

struct PlayView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var play: () -> Void
  
  let darkRed = Color(red: 168, green: 0, blue: 0)
  let green = Color(red: 51, green: 239, blue: 0)
  let gray = Color(red: 120, green: 120, blue: 120)

  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      VStack(alignment: .center) {
        Text("IMPOSSIBLE")
          .font(.custom("PressStart2P", size: 26))
          .foregroundColor(darkRed)
          .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
        Button("PLAY", action: play)
          .foregroundColor(green)
          .font(.custom("PressStart2P", size: 42))
        Button("BACK", action: { self.presentationMode.wrappedValue.dismiss() })
          .foregroundColor(gray)
          .font(.custom("PressStart2P", size: 42))
      }.frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity
      )
    }.navigationBarHidden(true)
  }
}
  

struct TitleView: View {

  let darkRed = Color(red: 168, green: 0, blue: 0)
  let green = Color(red: 51, green: 239, blue: 0)
  let gray = Color(red: 120, green: 120, blue: 120)

  var play: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Text("IMPOSSIBLE")
        .font(.custom("PressStart2P", size: 26))
        .foregroundColor(darkRed)
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
      Text("GAMES")
        .foregroundColor(.white)
        .font(.custom("PressStart2P", size: 52))
        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
      Spacer()
      NavigationLink(destination: PlayView(play: play)) {
        Text("PLAY")
          .foregroundColor(green)
          .font(.custom("PressStart2P", size: 42))
      }
      Spacer().frame(height: 20)
      Text("BUILD")
        .foregroundColor(gray)
        .font(.custom("PressStart2P", size: 42))
        .frame(height: 68)
        .overlay(ComingSoonOverlay(), alignment: .bottomTrailing)
      Spacer()
      Text("Code and Graphics")
        .foregroundColor(darkRed)
        .font(.custom("PressStart2P", size: 14))
      Text("David Byttow")
        .foregroundColor(gray)
        .padding(EdgeInsets(top: 6, leading: 0, bottom: 20, trailing: 0))
        .font(.custom("PressStart2P", size: 14))
    }.frame(
      minWidth: 0,
      maxWidth: .infinity,
      minHeight: 0,
      maxHeight: .infinity
    )
  }
}

struct ContentView: View {

  init(play: @escaping () -> Void) {
    self.play = play
    UINavigationBar.setAnimationsEnabled(false)
  }
  
  var play: () -> Void

  var body: some View {
    NavigationView {
      ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        TitleView(play: play)
      }.navigationBarHidden(true)
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(play: { print("hi") })
  }
}
#endif

