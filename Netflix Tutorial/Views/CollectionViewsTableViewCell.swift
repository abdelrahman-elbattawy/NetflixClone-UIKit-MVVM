//
//  CollectionViewsTableViewCell.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

class CollectionViewsTableViewCell: UITableViewCell {

    //MARK: - Properties
    static let identifier = "CollectionViewsTableViewCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
}

//MARK: - Configure CollectionView
extension CollectionViewsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
}
