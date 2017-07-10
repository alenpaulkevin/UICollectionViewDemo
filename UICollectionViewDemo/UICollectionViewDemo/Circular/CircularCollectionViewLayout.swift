//
//  CircularCollectionViewLayout.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/24.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    /// 每个item的大小
    let itemSize = CGSize(width: 133, height: 173)
    
    /// 属性数组
    var attributesList: [CircularCollectionViewLayoutAttributes] = []
    
    /// 设置半径，需要重新设置布局
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    
    /// 每两个item 之间的角度，任意值
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)  // atan反正切
    }
    
    /// 当collectionView滑到极端时，第 0个item的角度 （第0个开始是 0 度，  当滑到极端时， 最后一个是 0 度）
    var angleAtextreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    
    /// 滑动时，第0个item的角度
    var angle: CGFloat {
        return angleAtextreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView!.bounds.height)
    }
    
    /// 告诉类使用CircularCollectionViewLayoutAttributes类布局
    override class var layoutAttributesClass: Swift.AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        // 整体布局是将每个item设置在屏幕中心，然后旋转 anglePerItem * i 度
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2.0
        // 锚点的y值，多增加了raidus的值
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        /// 不要计算所有的item，只计算在屏幕中的item,theta最大倾斜
        let theta = atan2(collectionView!.bounds.width / 2, radius + (itemSize.height / 2.0) - collectionView!.bounds.height / 2)
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        // 开始位置
        if angle < -theta {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        // 结束为止
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        
        if endIndex < startIndex {
            endIndex = 0
            startIndex = 0
        }
        //  startIndex...endIndex
        attributesList = (startIndex...endIndex).map({ (i) -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            // 设置居中
            attributes.center = CGPoint(x: centerX, y: collectionView!.bounds.midY)
            // 设置偏移角度
            attributes.transform = CGAffineTransform(rotationAngle: self.angle + anglePerItem * CGFloat(i))
            // 锚点，我们自定义的属性
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        })
    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        
//    }
    
    // MARK: - 使卡片停在中间
    
    /// 重写滚动时停下的位置
    ///
    /// - Parameters:
    ///   - proposedContentOffset: 将要停止的点
    ///   - velocity: 滚动速度
    /// - Returns: 滚动停止的点
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var finalContentOffset = proposedContentOffset
        
        // 每单位偏移量对应的偏移角度
        let factor = -angleAtextreme / (collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x * factor
        
        // 大约偏移了多少个
        let ratio = proposedAngle / anglePerItem
        
        var multiplier: CGFloat
        
        // 往左滑动
        if velocity.x > 0 {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {  // 往右滑动
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        
        finalContentOffset.x = multiplier * anglePerItem / factor
        
        return finalContentOffset
        
    }
    
    // 返回布局数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


// MARK: - 自定义UICollectionViewLayoutAttributes 
/// 主要为了存储 anchorPoint,好在cell的apply(_:)方法中使用来旋转cell,因为UICollectionViewLayoutAttributes没有这个属性
class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    /// 需要实现这个方法，collection View  实时布局时，会copy参数，确保自身的参数被copy
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = anchorPoint
        return copiedAttributes
    }
}
