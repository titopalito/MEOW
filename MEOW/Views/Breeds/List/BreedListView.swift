//
//  BreedListView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 18.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class BreedListView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: BreedViewModel!
    private var selectedBreed: Breed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BreedViewModel() { [weak self] in
            self?.collectionView.reloadData()
        }
        setupCollectionView()
        fetch()
    }
    
    private func setupCollectionView() {
        collectionView.register(BreedCell.nib, forCellWithReuseIdentifier: BreedCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch() {
        viewModel.fetch()
    }
    
    override func viewDidLayoutSubviews() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
        let width = (view.frame.width - 44) / 3
        flow.itemSize = CGSize(width: width, height: 100)
        flow.minimumInteritemSpacing = 10
        flow.minimumLineSpacing = 10
    }
}

extension BreedListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCell.reuseID, for: indexPath) as? BreedCell {
            
            cell.configure(viewModel.dataSource[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let breed = viewModel.dataSource[indexPath.row]
        let details = BreedDetailsView(breed: breed)
        self.present(details, animated: true, completion: nil)
    }
    
    // MARK:- Context Menu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = NSString(string: viewModel.dataSource[indexPath.row].id)
        selectedBreed = self.viewModel.dataSource[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
            return BreedDetailsView(breed: self.selectedBreed!)
        }, actionProvider: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            guard let selectedBreed = self.selectedBreed else { return }
            let viewController = BreedDetailsView(breed: selectedBreed)
            self.show(viewController, sender: self)
        }
    }
}


