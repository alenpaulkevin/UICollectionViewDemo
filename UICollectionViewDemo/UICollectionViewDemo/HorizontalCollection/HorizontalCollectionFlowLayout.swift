//
//  HorizontalCollectionFlowLayout.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/21.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class HorizontalCollectionFlowLayout: UICollectionViewFlowLayout {
    
    var cols = 4 // 列数
    var line = 4  // 行数
    
    /// contentSize的最大宽度
    fileprivate var maxWidth: CGFloat = 0
    
    /// 布局frame数组
    fileprivate lazy var layoutAttributeArray: [UICollectionViewLayoutAttributes] = []

    
    override func prepare() {
        super.prepare()
        // 每个item的宽度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        // 每个item的高度
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(line - 1)) / CGFloat(line)
        
        // 求出对应的组数
        let sections = collectionView?.numberOfSections
        // 每个item所在组的 前面总的页数
        var prePageCount: Int = 0
        for i in 0..<sections! {
            // 每组的item的总的个数
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0..<itemCount {
                let indexPath = IndexPath(item: j, section: i)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // item 在 这一组内处于第几页
                let page = j / (cols * line)
                // item 在每一页内是处于第几个
                let index = j % (cols * line)
                
                // item的y值
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                
                // item的x值 为 左切距 + 前面页数宽度 + 在本页中的X值
                let itemX = sectionInset.left + CGFloat(prePageCount + page) * collectionView!.bounds.width + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                layoutAttributeArray.append(attr)
            }
            // 重置 PrePageCount
            prePageCount += (itemCount - 1) / (cols * line) + 1
        }
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}

extension HorizontalCollectionFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 找出相交的那些，别全部返回
        return layoutAttributeArray.filter { $0.frame.intersects(rect)}
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}
