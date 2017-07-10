//
//  WaterFlowLayout.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/20.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

protocol WaterFlowLayoutDelegate: NSObjectProtocol {
    func waterFlowLayout(_ waterFlowLayout: WaterFlowLayout, itemHeightAt indexPath: IndexPath) -> CGFloat
}

class WaterFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: WaterFlowLayoutDelegate?
    
    var cols = 4 // 列数
    
    /// 布局frame数组
    fileprivate lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []
    
    /// 每列的高度
    fileprivate lazy var yArray: [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
    
    fileprivate var maxHeight: CGFloat = 0
        
    override func prepare() {
        // 刷新时会重新调用次方法
        super.prepare()
        waterLayout()
    }
    
    /// 布局瀑布流
    private func waterLayout() {
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
                
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        // 最小高度的那一个的索引
        var minHeightIndex = 0
        
        // 从 layoutAttributeArray.count 开始，避免重复加载
        for j in layoutAttributeArray.count ..< itemCount {
            let indexPath = IndexPath(item: j, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let itemH = delegate?.waterFlowLayout(self, itemHeightAt: indexPath)
            
            // 找出最小高度的那一列
            let value = yArray.min()
            minHeightIndex = yArray.index(of: value!)!
            
            var itemY = yArray[minHeightIndex]
            // 大于第一行的高度才相加
            if j >= cols {
                itemY += minimumInteritemSpacing
            }
            
            let itemX = sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(minHeightIndex)
            
            attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: CGFloat(itemH!))
            layoutAttributeArray.append(attr)
            // 重新设置高度
            yArray[minHeightIndex] = attr.frame.maxY
        }
        maxHeight = yArray.max()! + sectionInset.bottom
    }
}

extension WaterFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 找出相交的那些，别全部返回
      //  return layoutAttributeArray

       return layoutAttributeArray.filter { $0.frame.intersects(rect)}
    }
    
    override var collectionViewContentSize: CGSize {
        // 这里宽度不能设置为0
        return CGSize(width: collectionView!.bounds.width, height: maxHeight)
    }
}
