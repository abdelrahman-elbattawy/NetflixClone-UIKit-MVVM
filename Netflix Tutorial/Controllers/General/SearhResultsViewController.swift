//
//  SearhResultsViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 08/07/2023.
//

import UIKit

protocol SearhResultsViewControllerDelegate: AnyObject {
    func searhResultsViewControllerDidTapItem(with model: TitlePreviewModelView)
}

class SearhResultsViewController: UIViewController {

    //MARK: - Properties
    public var titles: [Title] = [Title]()
    
    weak var delegate: SearhResultsViewControllerDelegate?
    
    public let resultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        resultsCollectionView.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(resultsCollectionView)
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
    }

}

//MARK: - CollectionView Extention
extension SearhResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        
        if let posterPath = title.poster_path {
            cell.configure(with: posterPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        guard let titleOverview = title.overview else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let videoElement):
                let viewModel = TitlePreviewModelView(titleName: titleName, titleOverview: titleOverview, videoElement: videoElement)
                self?.delegate?.searhResultsViewControllerDidTapItem(with: viewModel)
            }
        }
    }
}


