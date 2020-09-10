//
//  ContentView.swift
//  ImpossibleGames
//
//  Created by David Byttow on 9/4/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  var play: () -> ()
      
  var body: some View {
    VStack {
      Text("IMPOSSIBLE")
        .foregroundColor(Color.red)
      Text("GAMES")
      Button("Play", action: play)
        .foregroundColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
      Text("Code and Graphics")
        .foregroundColor(Color.red)
      Text("David Byttow")
    }
    .frame(width: nil)
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(play: { print("hi") })
  }
}
#endif

