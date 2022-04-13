//
//  MovieConfigurableCell.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 11/04/22.
//

import Foundation

protocol MovieConfiguringCellProtocol {
    static var reuseIdentifier: String { get }
    func configure(with movie: MovieList)
}
