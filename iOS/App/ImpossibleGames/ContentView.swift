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

struct Score : Identifiable {
  let id = UUID()
  let name: String
  let time: String
}

struct Leaderboard : View {
  var ranks = [
    "1ST",
    "2ND",
    "3RD",
    "4TH",
    "5TH",
  ]
  
  var scores = [
    Score(name: "jbyttow", time: "1:42"),
    Score(name: "SirBenLee", time: "2:34"),
    Score(name: "counterpoint0", time: "2:35"),
    Score(name: "AbsoluteUnit", time: "3:01"),
    Score(name: "RickyBobby", time: "4:55"),
  ]
  
  let font = Font.custom("PressStart2P", size: 10)
      
  var body: some View {
//    ZStack {
//      HStack {
//        List {
//          Section(header: Text("").font(font)) {
//            ForEach(ranks, id: \.self) { rank in
//              Text(rank).font(font)
//            }
//          }
//        }.background(Color.black)
//        List {
//          Section(header: Text("TIME").font(font)) {
//            ForEach(scores, id: \.id) { score in
//              Text(scores[0].time).font(font)
//            }
//          }
//        }.background(Color.black)
//        List {
//          Section(header: Text("NAME").font(font)) {
//            ForEach(scores, id: \.id) { score in
//              Text(scores[0].name).font(font)
//            }
//          }
//        }.background(Color.black)
//      }
//    }

    VStack {
      List(0 ..< min(scores.count, ranks.count) + 1) { i in
        if i == 0 {
          HStack {
            Text("")
              .font(font)
            Text("TIME")
              .font(font)
            Text("NAME")
              .font(font)
          }
        } else {
          HStack {
            Text(self.ranks[i])
              .font(font)
            Text(scores[i].time)
              .font(font)
            Text(scores[i].name)
              .font(font)
          }
        }
      }
    }
  }
}

struct PlayView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var play: () -> Void
  @State private var loaded = false
  
  let darkRed = Color(red: 168, green: 0, blue: 0)
  let green = Color(red: 51, green: 239, blue: 0)
  let gray = Color(red: 120, green: 120, blue: 120)
  let brown = Color(red: 230, green: 152, blue: 54)
  
  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      VStack(alignment: .center) {
        Text("Today's Game")
          .font(.custom("PressStart2P", size: 21))
          .foregroundColor(Color.white)
          .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
        Image("unknown-game")
          .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
        Text("???")
          .font(.custom("PressStart2P", size: 16))
          .foregroundColor(brown)
          .padding(EdgeInsets(top: 13, leading: 0, bottom: 0, trailing: 0))
        Button("START", action: play)
          .foregroundColor(loaded ? green : gray)
          .font(.custom("PressStart2P", size: 40))
          .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
        Leaderboard()
        Spacer()
        Button("Load", action: { self.loaded = !self.loaded })
          .foregroundColor(loaded ? green : gray)
          .font(.custom("PressStart2P", size: 12))
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
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
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
    }.navigationBarHidden(true)
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
      TitleView(play: play)
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    //ContentView(play: { print("hi") })
    PlayView(play: { print("hi") })
  }
}
#endif

