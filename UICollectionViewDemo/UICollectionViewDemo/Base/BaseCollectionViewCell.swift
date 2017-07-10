//
//  BaseCollectionViewCell.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/20.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var cellIndex: Int = 0 {
        didSet {
            textLabel.text = "\(cellIndex)"
        }
    }
    
    private var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel()
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
        backgroundColor = .orange
    }
    
    /// 流水布局，因为控件会实时变化，需要在这里计算frame,如果控件大小固定，推荐直接在init方法里算
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
