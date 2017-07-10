//
//  CircularCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/24.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CircularCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(CircularCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)        
    }
}

extension CircularCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as! CircularCollectionViewCell
        cell.cellIndex = indexPath.item
        cell.backgroundColor = indexPath.item % 2 == 0 ? .purple : .lightGray
        return cell
    }
}
