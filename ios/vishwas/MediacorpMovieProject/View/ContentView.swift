//
//  ContentView.swift
//  MediacorpMovieProject
//
//  Created by Vishwas Anandani on 11/04/22.
//

import SwiftUI
import Foundation
import UIKit

var movieDataPopular: [Results] = []
var movieDataUpComing: [Results] = []

struct ContentView: View {
    
    let check: () = performGetRequest()
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 12) {
                Text(movieApp)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    
            
                Text(popularMovie)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(movieDataPopular,id :\.id) { movie in
                            MovieThumbnailView(movie: movie).frame(width: 200, height: 200)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                Text(upcomingMovie)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(movieDataUpComing,id :\.id) { movie in
                            MovieThumbnailView(movie: movie).frame(width: 200, height: 200)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
            }
        }
            
        }
        }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

