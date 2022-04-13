//
//  ViewController.swift
//  MovieListing
//
//  Created by Rajasekaran Gopal on 10/04/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    //MARK: - Outlet Declaration
    var collectionView: UICollectionView!
    
    //MARK: - Property Declaration
    enum MovieSections: String {
        case popularMovie = "Popular Movies"
        case upcomingMovie = "Upcoming Movies"
    }
    var dataSource: UICollectionViewDiffableDataSource<MovieSections,MovieList>?
    var snapShot = NSDiffableDataSourceSnapshot<MovieSections,MovieList>()
    
    
    var movieViewModel:MovieListviewModel = MovieListviewModel()
    var popularMovieList: [MovieList]?
    var upcomingMovieList: [MovieList]?
    var limit = 20
    var totalPopularMoviePages = 0
    var totalUpcomingMoviewPages = 0
    var popularMovieCurrentPage = 0
    var upcomingMovieCurrentPage = 0
    private var isPageRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    
    //MARK: - Custom Methods
    private func initalSetup(){
        collectionViewSetup()
        callMovieListAPI()
        configureDataSource()
    }
    
    private func collectionViewSetup(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createCompositionalLayout()!)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        //Register Cells
        collectionView.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewSectionHeader.reuseIdentifier)
        collectionView.register(SmallGridLayoutCollectionViewCell.self, forCellWithReuseIdentifier: SmallGridLayoutCollectionViewCell.reuseIdentifier)
    }
    
    private func callMovieListAPI(){
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        self.callPopularMovieAPI(pageNumber: 1) {}
        self.callUpcomingMovieAPI(pageNumber: 1) {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main){
            self.reloadDataWithSnapShot()
        }
    }
    
    //MARK: Diffable datasource configurations
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<MovieSections,MovieList>(collectionView: self.collectionView, cellProvider: { (collectionView, indexpath, movieList) -> UICollectionViewCell? in
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: SmallGridLayoutCollectionViewCell.reuseIdentifier,
                                                           for: indexpath) as? SmallGridLayoutCollectionViewCell
            
            cell?.configure(with: movieList)
            return cell
            
        })
        collectionViewSectionHeaderSetup()
    }
    
    private func collectionViewSectionHeaderSetup(){
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            //Here we need to provide a view for a section header
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewSectionHeader.reuseIdentifier, for: indexPath) as? CollectionViewSectionHeader else {
                return nil
            }
            
            sectionHeader.sectionTitle.text = indexPath.section == 0 ? MovieSections.popularMovie.rawValue : MovieSections.upcomingMovie.rawValue
            return sectionHeader
        }
    }
    
    private func reloadDataWithSnapShot(){
        snapShot.appendSections([.popularMovie,
                                 .upcomingMovie])
        
        snapShot.appendItems(popularMovieList ?? [], toSection: .popularMovie)
        snapShot.appendItems(upcomingMovieList ?? [], toSection: .upcomingMovie)
        
        dataSource?.apply(snapShot)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout?{
        
        let compositionalLayout = UICollectionViewCompositionalLayout { [self] sectionIndex, layoutEnvironment in
            let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75),
                                                        heightDimension: .fractionalHeight(0.65))
            
            let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 15)
            
            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(180),
                                                         heightDimension: .estimated(380))
            
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            layoutSection.contentInsets  = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            layoutSection.boundarySupplementaryItems = [self.createCollectionViewSectionHeaderLayout()]
            
            return layoutSection
        }
        return compositionalLayout
    }
    
    
    func createCollectionViewSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem{
        let sectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(30))
        let sectionSupplementaryView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionSize,
                                                                                   elementKind: UICollectionView.elementKindSectionHeader,
                                                                                   alignment: .top)
        return sectionSupplementaryView
    }
    
}


extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section  == 0 {
            if indexPath.row == popularMovieList!.count - 1 {
                //Handling the pagenation here
                if popularMovieCurrentPage < totalPopularMoviePages  &&
                    !isPageRefreshing {
                    self.isPageRefreshing = true
                    popularMovieCurrentPage += 1
                    
//                    self.tablView.tableFooterView = createSpinnerFooter()
                    self.callPopularMovieAPI(pageNumber: popularMovieCurrentPage) {}
                   
                }
            }
        } else {
            if indexPath.row == upcomingMovieList!.count - 1 {
                //Handling the pagenation here
                if upcomingMovieCurrentPage < totalUpcomingMoviewPages  &&
                    !isPageRefreshing {
                    self.isPageRefreshing = true
                    upcomingMovieCurrentPage += 1
                    
//                    self.tablView.tableFooterView = createSpinnerFooter()
                    self.callUpcomingMovieAPI(pageNumber: upcomingMovieCurrentPage) {}
                }
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section  == 0 {
            let selectedMovie =  self.popularMovieList?[indexPath.row]
            
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.selectedMovie = selectedMovie
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        else {
            let selectedMovie =  self.upcomingMovieList?[indexPath.row]
            
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.selectedMovie = selectedMovie
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


extension ViewController {
    private func callPopularMovieAPI(pageNumber: Int, completion: @escaping () -> ()){
        self.movieViewModel.callPopularMovieListAPI(with: pageNumber) { content in
            guard let listOfMovies = content.results else {return}
            if self.popularMovieCurrentPage == 0 {
                self.popularMovieList = listOfMovies
            }
            else {
                self.popularMovieList?.append(contentsOf: listOfMovies)
            }
            self.totalPopularMoviePages = content.totalPages ?? 1
            self.isPageRefreshing = false
            completion()
        } failureHandler: { error in
            //MARK: - Handle Failure here
        }
    }
    
    private func callUpcomingMovieAPI(pageNumber: Int, completion: @escaping () -> ()){
        self.movieViewModel.callUpcomingMovieListAPI(with: pageNumber) { content in
            guard let listOfUpcomingMovies = content.results else {return}
            if self.upcomingMovieCurrentPage == 0 {
                self.upcomingMovieList = listOfUpcomingMovies
            }
            else {
                self.upcomingMovieList?.append(contentsOf: listOfUpcomingMovies)
            }
            self.totalUpcomingMoviewPages = content.totalPages ?? 1
            self.isPageRefreshing = false
            completion()
        } failureHandler: { error in
            //MARK: - Handle Failure here
        }
    }
}
