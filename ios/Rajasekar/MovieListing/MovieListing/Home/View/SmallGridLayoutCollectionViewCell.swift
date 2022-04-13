//
//  SmallGridLayoutCollectionViewCell.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 11/04/22.
//

import UIKit

class SmallGridLayoutCollectionViewCell: UICollectionViewCell,
                                         MovieConfiguringCellProtocol {
    //MARK: - Property Declarations
    static var reuseIdentifier: String = "SmallGridLayoutCollectionViewCell"
    let movieTitle = UILabel()
    let movieIconImageView = UIImageView()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Custom methods
    private func makeCellUI(){
        movieTitle.font = .systemFont(ofSize: 14)
        movieTitle.textColor = .label
        
        movieIconImageView.layer.cornerRadius = 5
        movieIconImageView.clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [movieIconImageView,movieTitle])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            movieIconImageView.widthAnchor.constraint(equalToConstant: 150),
            movieIconImageView.heightAnchor.constraint(equalToConstant: 200),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with movie: MovieList) {
        movieTitle.text = movie.title
        if let movieURL = movie.posterPath {
            self.movieIconImageView.loadImageUsingCache(withUrl: API.BaseUrl + movieURL, placeHolderImage: UIImage(named: "TS3")!)
        }else{
            self.movieIconImageView.image = UIImage(named: "TS3")
        }
    }
    
}
