//
//  CoverFlowLayout.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/23.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class CoverFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 获取这个范围的布局数组
        let attributes = super.layoutAttributesForElements(in: rect)
        // 找到中心点
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2
        
        // 每个点根据距离中心点距离进行缩放
        attributes!.forEach({ (attr) in
            let pad = abs(centerX - attr.center.x)
            let scale = 1.8 - pad / collectionView!.bounds.width
            attr.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
        return attributes
    }
    
    /// 重写滚动时停下的位置
    ///
    /// - Parameters:
    ///   - proposedContentOffset: 将要停止的点
    ///   - velocity: 滚动速度
    /// - Returns: 滚动停止的点
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var targetPoint = proposedContentOffset
        
        // 中心点
        let centerX = proposedContentOffset.x + collectionView!.bounds.width
        
        // 获取这个范围的布局数组
        let attributes = self.layoutAttributesForElements(in: CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height))
        
        // 需要移动的最小距离
        var moveDistance: CGFloat = CGFloat(MAXFLOAT)
        // 遍历数组找出最小距离
        attributes!.forEach { (attr) in
            if abs(attr.center.x - centerX) < abs(moveDistance) {
                moveDistance = attr.center.x - centerX
            }
        }
        // 只有在ContentSize范围内，才进行移动
        if targetPoint.x > 0 && targetPoint.x < collectionViewContentSize.width - collectionView!.bounds.width {
            targetPoint.x += moveDistance
        }
        
        return targetPoint
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {        
        return CGSize(width:sectionInset.left + sectionInset.right + (CGFloat(collectionView!.numberOfItems(inSection: 0)) * (itemSize.width + minimumLineSpacing)) - minimumLineSpacing, height: 0)
    }
}
