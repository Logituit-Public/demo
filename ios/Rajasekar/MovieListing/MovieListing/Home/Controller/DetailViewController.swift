//
//  DetailViewController.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 13/04/22.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedMovie:MovieList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .UISetup()
       
        // Do any additional setup after loading the view.
    }
    

    func UISetup() {
        let imgView = UIImageView(frame: CGRect(x: 40, y: 20, width: view.frame.size.width - 80, height: 200)
        )
        imgView.center = view.center
        if let movieURL = selectedMovie.posterPath {
            imgView.loadImageUsingCache(withUrl: API.BaseUrl + movieURL, placeHolderImage: UIImage(named: "TS3")!)
        }else{
            imgView.image = UIImage(named: "TS3")
        }
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        let titleLbl = UILabel(frame: CGRect(x: imgView.frame.minX, y: imgView.frame.maxY, width: view.frame.size.width - 80, height: 200)
        )
        titleLbl.text = selectedMovie.title
        titleLbl.textAlignment = .center
        view.addSubview(titleLbl)
    }
    

}
