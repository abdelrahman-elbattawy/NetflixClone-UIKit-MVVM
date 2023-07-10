//
//  CollectionViewsTableViewCell.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

protocol CollectionViewsTableViewCellDelegate: AnyObject {
    func collectionViewsTableViewCellDidTapCell(_ cell: CollectionViewsTableViewCell, viewModel: TitlePreviewModelView)
}

class CollectionViewsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CollectionViewsTableViewCell"
    
    var titles: [Title] = [Title]()
    
    weak var delegate: CollectionViewsTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func configue(titles: [Title]) {
        DispatchQueue.main.async { [weak self] in
            self?.titles = titles
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTapItem(indexPath: IndexPath) {
        
        let title = titles[indexPath.row]
        DataPersistenceManager.shared.downloadTitleWith(model: title) { results in
            switch results {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Configure CollectionView
extension CollectionViewsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let posterPath = titles[indexPath.row].poster_path ?? ""
        cell.configure(with: posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {return}
        guard let titleOverview = title.overview else {return}
        
        APICaller.shared.getMovie(with: titleName + " trailer") { retults in
            switch (retults) {
            case .success(let videoElement):
                let viewModel = TitlePreviewModelView(titleName: titleName, titleOverview: titleOverview, videoElement: videoElement)
                
                self.delegate?.collectionViewsTableViewCellDidTapCell(self, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", state: .off) { _ in
                    self.downloadTapItem(indexPath: indexPath)
                }
                
                return UIMenu(options: .displayInline, children: [downloadAction])
            }
        
        return config
        
    }
}

