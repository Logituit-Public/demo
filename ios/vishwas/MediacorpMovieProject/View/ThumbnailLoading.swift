//
//  ThumbnailLoading.swift
//  MediacorpMovieProject
//
//  Created by Vishwas Anandani on 12/04/22.
//

import Foundation
import SwiftUI

struct MovieThumbnailView: View {
    
    let movie: Results
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        return NavigationLink(destination: DetailView(movie: movie)) {
        containerView
        .onAppear {
            imageLoader.loadImage(with:urlHeader+movie.poster_path!)
        }
    }
    }
    
    @ViewBuilder
    private var containerView: some View {
        VStack(alignment: .leading, spacing: 8) {
                imageView
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
            }
    }
    
    
    
    private var imageView: some View {
        ZStack {
            Color.gray.opacity(0.3)
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .layoutPriority(-1)
            }
        }
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}



struct MoviePosterCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieThumbnailView(movie: movieDataPopular[0])
                .frame(width: 204, height: 306)
        }
    }
}
