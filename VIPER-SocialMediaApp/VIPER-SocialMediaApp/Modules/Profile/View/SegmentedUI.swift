//
//  SegmentedUI.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 3.06.2023.
//

import Foundation
import UIKit


class ProfileSegmentedView: UIView {
    private let segmentedControl = UISegmentedControl(items: ["Posts", "Lists", "About"])
    private var collectionView: UICollectionView!
    private let collectionViewLayout = UICollectionViewFlowLayout()
    var posts: [Post] = []
    private var presenter: HomePresenterProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        layoutSubviews()
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)  
        setupCollectionView()
        layoutSubviews()
    }
    
    private func setupCollectionView() {
        collectionViewLayout.itemSize = CGSize(width: 420, height: 360)
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
     
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(segmentedControl)
        addSubview(collectionView)
        
        collectionView.frame = bounds
        segmentedControl.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 50)
    }
    
}

extension ProfileSegmentedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        var post = posts[indexPath.item]
        cell.configure(with: post, presenter: HomePresenter(view: HomeViewController(), interactor: HomeInteractor(service: NetworkManager()), router: HomeRouter(viewController: HomeViewController())))
        return cell
    }
}

