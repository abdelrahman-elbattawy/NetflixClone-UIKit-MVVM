//
//  HomeViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewsTableViewCell.self, forCellReuseIdentifier: CollectionViewsTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
}

//MARK: - Configure TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewsTableViewCell.identifier, for: indexPath) as? CollectionViewsTableViewCell else {
            return UITableViewCell()
        }
        
        switch(indexPath.section) {
        case sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch (results) {
                case .success(let titles):
                    cell.configue(titles: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { results in
                switch (results) {
                case .success(let titles):
                    cell.configue(titles: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case sections.PopularMovies.rawValue:
            APICaller.shared.getTrendingPopular { results in
                switch (results) {
                case .success(let titles):
                    cell.configue(titles: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case sections.UpcomingMovies.rawValue:
            APICaller.shared.getTrendingUpcoming { results in
                switch (results) {
                case .success(let titles):
                    cell.configue(titles: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case sections.TopRatedMovies.rawValue:
            APICaller.shared.getTrendingTopRated { results in
                switch (results) {
                case .success(let titles):
                    cell.configue(titles: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffest = view.safeAreaInsets.top
        let offest = defaultOffest + scrollView.contentOffset.y
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offest))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

