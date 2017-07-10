//
//  CoverFlowViewController.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/23.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

private let baseCellID = "baseCellID"

class CoverFlowViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        setUpView()
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bringMiddleCellToFront() // 把中间的cell的放在最前面
    }
    
    /// 把中间的cell带到最前面
    fileprivate func bringMiddleCellToFront() {
        let pointX = (collectionView.contentOffset.x + collectionView.bounds.width / 2)
        let point = CGPoint(x: pointX, y: collectionView.bounds.height / 2)
        let indexPath = collectionView.indexPathForItem(at: point)
        if let letIndexPath = indexPath {
            let cell = collectionView.cellForItem(at: letIndexPath)
            guard let letCell = cell else {
                return
            }
            // 把cell放到最前面
            collectionView.bringSubview(toFront: letCell)
        }
    }
    
    private func setUpView() {
        // 创建flowLayout对象
        let layout = CoverFlowLayout()
        
        let margin: CGFloat = 40
        let collH: CGFloat = 200
        let itemH = collH - margin * 2
        let itemW = (view.bounds.width - margin * 4) / 3
        layout.itemSize = CGSize(width: itemW, height: itemH);
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        layout.scrollDirection = .horizontal
        // 创建collection
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 180, width: view.bounds.width, height: collH), collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册cell
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: baseCellID)
        view.addSubview(collectionView)
        
    }
}

extension CoverFlowViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellID, for: indexPath) as! BaseCollectionViewCell
        cell.cellIndex = indexPath.item
        cell.backgroundColor = indexPath.item % 2 == 0 ? .purple : .lightGray
        return cell
    }
}

extension CoverFlowViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bringMiddleCellToFront()
    }
}


