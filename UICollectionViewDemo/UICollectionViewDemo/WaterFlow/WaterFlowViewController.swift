//
//  WaterFlowViewController.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/20.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

private let baseCellID = "baseCellID"
class WaterFlowViewController: UIViewController {
    
    var itemCount: Int = 30
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        // 创建flowLayout对象
        let layout = WaterFlowLayout()
        layout.delegate = self
        // 设置列数
        layout.cols = 3

        let margin: CGFloat = 8
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        // 创建collection
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        // 注册cell
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: baseCellID)
        view.addSubview(collectionView)
    }
}

extension WaterFlowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellID, for: indexPath) as! BaseCollectionViewCell
        cell.cellIndex = indexPath.item
        cell.backgroundColor = indexPath.item % 2 == 0 ? .purple : .lightGray
        if itemCount - 1 == indexPath.item {
            itemCount += 20
            collectionView.reloadData()
        }
        return cell
    }
}

extension WaterFlowViewController: WaterFlowLayoutDelegate {
    func waterFlowLayout(_ waterFlowLayout: WaterFlowLayout, itemHeightAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 50)
    }
}
