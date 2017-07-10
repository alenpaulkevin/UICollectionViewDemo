//
//  CircularCollectionViewCell.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/24.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
    var cellIndex: Int = 0 {
        didSet {
            textLabel.text = "\(cellIndex)"
        }
    }
    
    private var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel(frame: bounds)
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
        backgroundColor = .orange
    }
    
    // 设置选中的背景颜色
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .lightGray
            } else {
                contentView.backgroundColor = nil
            }
            super.isSelected = isSelected
        }
    }
    
    // 设置高亮颜色
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                contentView.backgroundColor = .purple
            } else {
                contentView.backgroundColor = nil
            }
            super.isHighlighted = isHighlighted
        }
    }
    
     override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        layer.anchorPoint = circularlayoutAttributes.anchorPoint
        layer.position.y = layer.position.y + (circularlayoutAttributes.anchorPoint.y - 0.5) * bounds.height
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
