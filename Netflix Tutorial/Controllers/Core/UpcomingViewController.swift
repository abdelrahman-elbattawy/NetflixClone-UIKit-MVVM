//
//  UpcomingViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    //MARK: - Properties
    private var titles: [Title] = [Title]()
    
    private let upcomingFeedTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingFeedTable.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(upcomingFeedTable)
        upcomingFeedTable.dataSource = self
        upcomingFeedTable.delegate = self
    }
    
    private func fetchUpcomingMovies() {
        APICaller.shared.getTrendingUpcoming { [weak self] results in
            switch (results) {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingFeedTable.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extensions
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        let titleName = title.original_name ?? title.original_title ?? "Unkwon title name"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        guard let titleOverview = title.overview else {return}
        
        APICaller.shared.getMovie(with: titleName) { results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async { [weak self] in
                    
                    let viewModel = TitlePreviewModelView(titleName: titleName, titleOverview: titleOverview, videoElement: videoElement)
                    let vc = TitlePreviewViewController()
                    vc.configue(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
