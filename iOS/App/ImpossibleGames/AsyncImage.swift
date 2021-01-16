//
//  ImageContainer.swift
//  ImpossibleGames
//
//  Created by David Byttow on 11/8/20.
//  Copyright © 2020 Simple Things LLC. All rights reserved.
//

import SwiftUI
import Combine

protocol ImageCache {
  subscript(_ url: URL) -> UIImage? { get set }
}

class ImageLoader : ObservableObject {
  @Published var image: UIImage?
  private let url: URL
  private var cache: ImageCache?
  private var cancellable: AnyCancellable?
  
  init(url: URL, cache: ImageCache? = nil) {
    self.url = url
    self.cache = cache
  }
  
  deinit {
    cancel()
  }

  func load() {
    if let image = cache?[url] {
      self.image = image
      return
    }
    
    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.image = $0 }
  }
  
  func cancel() {
    cancellable?.cancel()
  }
}

struct AsyncImage<Placeholder: View> : View {
  @StateObject private var loader: ImageLoader
  private let placeholder: Placeholder
  
  init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
    self.placeholder = placeholder()
    _loader = StateObject(wrappedValue: ImageLoader(url: url))
  }
  
  var body : some View {
    content.onAppear(perform: loader.load)
  }
  
  private var content : some View {
    Group {
      if loader.image != nil {
        Image(uiImage: loader.image!).resizable().aspectRatio(contentMode: .fit)
      } else {
        placeholder
      }
    }
  }
}
