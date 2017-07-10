//
//  InteractiveMoveViewController.swift
//  UICollectionViewDemo
//
//  Created by CaoXuan on 2017/7/9.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

private let interactiveMoveCellID = "interactiveMoveCellID"
class InteractiveMoveViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    fileprivate lazy var dataNumbers: [Int] =  {
        var number = [Int]()
        for num in 0...100 {
            let height = num
            number.append(height)
        }
        return number
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 创建flowLayout对象
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 8
        let itemW = (view.bounds.width - margin * 4) / 3
        let itemH = itemW
        layout.itemSize = CGSize(width: itemW, height: itemH)
        
        // 最小行间距
        layout.minimumLineSpacing = margin
        
        // 最小item之间的距离
        layout.minimumInteritemSpacing = margin
        
        // 每组item的边缘切距
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        
        // 滚动方向
        layout.scrollDirection = .vertical
        
        // 创建collection
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // 分页拖动
//        collectionView.isPagingEnabled = true
        

        // 注册cell
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: interactiveMoveCellID)
        view.addSubview(collectionView)
        
        // 添加手势进行重排
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            // 开始交互
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            // 更新位置
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            // 结束交互
            collectionView.endInteractiveMovement()
        default:
            // 默认取消交互
            collectionView.cancelInteractiveMovement()
        }
    }

}

extension InteractiveMoveViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: interactiveMoveCellID, for: indexPath) as! BaseCollectionViewCell
        cell.cellIndex = dataNumbers[indexPath.item]
        cell.backgroundColor = indexPath.item % 2 == 0 ? .purple : .lightGray
        return cell
    }
        
    /// 更新我们自己的数据源
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let number = dataNumbers.remove(at: sourceIndexPath.item)
        dataNumbers.insert(number, at: destinationIndexPath.item)
    }
}










