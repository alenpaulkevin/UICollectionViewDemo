//
//  MoveCollectionViewCell.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/24.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class MoveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func begainAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = -Double.pi / 40
        animation.toValue = Double.pi / 40
        animation.duration = 0.15
        animation.isRemovedOnCompletion = false
        animation.repeatCount = MAXFLOAT
        animation.autoreverses = true
        layer.add(animation, forKey: "animation")
    }
    
    func stopAnimation() {
        layer.removeAllAnimations()
    }

}
