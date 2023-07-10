//
//  DownloadsViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    //MARK: - Properties
    private var titles: [TitleItem] = [TitleItem]()
    private let downloadsTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchTitlesFromLocalStorage()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchTitlesFromLocalStorage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadsTable.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(downloadsTable)
        downloadsTable.dataSource = self
        downloadsTable.delegate = self
    }
    
    private func fetchTitlesFromLocalStorage() {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let titles):
                DispatchQueue.main.async { [weak self] in
                    self?.titles = titles
                    self?.downloadsTable.reloadData()
                }
            }
        }
    }
}


//MARK: - TableView Extentions
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]

        if let titleName = title.original_name ?? title.original_title, let posterPath = title.poster_path {
            let viewModel = TitleModelView(titleName: titleName, posterPath: posterPath)
            cell.configure(with: viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let title = titles[indexPath.row]
        DataPersistenceManager.shared.deleteTitleFromDatabase(model: title) { results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success():
                print("Deleted item")
            }
        }
        
        self.titles.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        guard let titleOverview = title.overview else {return}
        
        APICaller.shared.getMovie(with: titleName) { results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let videoElement):
                let viewModel = TitlePreviewModelView(titleName: titleName, titleOverview: titleOverview, videoElement: videoElement)
                
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    vc.configue(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
