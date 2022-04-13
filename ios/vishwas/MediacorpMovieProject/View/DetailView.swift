//
//  DetailView.swift
//  MediacorpMovieProject
//
//  Created by Vishwas Anandani on 12/04/22.
//

import Foundation
import SwiftUI

var imageData = Data()

struct DetailView: View {
    var movie: Results
    var body: some View{
        var _ = image_processing(urlstring:urlHeader+movie.poster_path!)
        VStack(spacing: 12){
            Image(uiImage:UIImage(data: imageData)!).resizable()
                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(20)
                .scaledToFit()
            Text(movie.title)
            Text(releaseDate + movie.release_date)
            Text(movie.overview)
          Spacer()
        }
    }
}
