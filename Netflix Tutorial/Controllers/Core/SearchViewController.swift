//
//  SearchViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: - Properties
    private var titles: [Title] = [Title]()
    
    private let discoverFeedTable: UITableView = {
       let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverFeedTable.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverFeedTable)
        discoverFeedTable.dataSource = self
        discoverFeedTable.delegate = self
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] results in
            switch (results) {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverFeedTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Extensions
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        let titleName = title.original_name ?? title.original_title ?? "Unkown title name"
        let posterPath = title.poster_path ?? ""
        
        cell.configure(with: TitleModelView(titleName: titleName, posterPath: posterPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffest = view.safeAreaInsets.top
        let offest = defaultOffest + scrollView.contentOffset.y
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offest))
    }
}
