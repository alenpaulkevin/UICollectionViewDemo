//
//  HorizontalCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/23.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

private let baseCellID = "baseCellID"
class HorizontalCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        setUpView()
    }
    
    private func setUpView() {
        // 创建flowLayout对象
        let layout = HorizontalCollectionFlowLayout()
        // 设置列数
        layout.cols = 4
        layout.line = 4
        

        let margin: CGFloat = 8
      //  layout.itemSize = CGSize(width: (view.bounds.width - margin * 5) / 4, height: (view.bounds.width - margin * 3) / 4);
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        layout.scrollDirection = .horizontal
        // 创建collection
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: 380), collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        // 注册cell
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: baseCellID)
        view.addSubview(collectionView)
        
    }
}

extension HorizontalCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13 + section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellID, for: indexPath) as! BaseCollectionViewCell
        cell.cellIndex = indexPath.item
        cell.backgroundColor = indexPath.item % 2 == 0 ? .purple : .lightGray
        return cell
    }
}

