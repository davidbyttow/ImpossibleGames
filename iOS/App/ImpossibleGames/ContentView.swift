//
//  ContentView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  let green = Color(red: 0.2, green: 0.94, blue: 0)
  
  var play: () -> ()
      
  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      GeometryReader { g in
        VStack(alignment: .center) {
          Text("IMPOSSIBLE")
            .font(.custom("PressStart2P", size: 26))
            .foregroundColor(Color.red)
            .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
          Text("GAMES")
            .foregroundColor(Color.white)
            .font(.custom("PressStart2P", size: 52))
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
          Spacer()
          Button("PLAY", action: self.play)
            .foregroundColor(self.green)
            .font(.custom("PressStart2P", size: 48))
          Spacer()
          Text("Code and Graphics")
            .foregroundColor(Color.red)
            .font(.custom("PressStart2P", size: 14))
          Text("David Byttow")
            .foregroundColor(Color.white)
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 10, trailing: 0))
            .font(.custom("PressStart2P", size: 14))
        }.frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity
        )
      }
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

