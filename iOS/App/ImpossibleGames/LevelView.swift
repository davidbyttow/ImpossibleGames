//
//  LevelView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/19/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

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

struct LevelView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  var play: () -> Void
  @Binding var levelData: LevelData

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
          .onAppear(perform: loadLevelData)
        Image(loaded ? "level-thumbnail" : "unknown-game")
          .padding(EdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0))
          .onTapGesture(perform: {
            if !loaded {
              loaded = true
            }
          });
        Text(levelData.title)
          .font(.custom("PressStart2P", size: 16))
          .foregroundColor(brown)
          .padding(EdgeInsets(top: 13, leading: 0, bottom: 0, trailing: 0))
        Button("START", action: {
          if loaded {
            play()
          }
        })
          .foregroundColor(loaded ? green : gray)
          .font(.custom("PressStart2P", size: 40))
          .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
//        Leaderboard()
        Spacer()
//        Button("Load", action: { self.loaded = !self.loaded })
//          .foregroundColor(loaded ? green : gray)
//          .font(.custom("PressStart2P", size: 12))
      }.frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity
      )
    }.navigationBarHidden(true)
  }

  private func delayLoad() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      loaded = true
    }
  }
  
  private func loadLevelData() {
    guard let url = URL(string: "https://www.davidbyttow.com/api/get-level") else {
      return
    }

    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        if let responseObj = try? JSONDecoder().decode(LevelData.self, from: data) {
          DispatchQueue.main.async {
            loaded = true
            print("Setting data \(responseObj)")
            self.levelData = responseObj
          }
        }
      }
    }.resume()
}
}

//#if DEBUG
//struct LevelView_Previews: PreviewProvider {
//  static var previews: some View {
//    LevelView(play: { print("hi") })
//  }
//}
//#endif
//
