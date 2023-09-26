//
//  MoveCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/7/7.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "Cell"
private let headerReuseIdentifier = "Cell"

class MoveCollectionViewController: UICollectionViewController {
    
    /// 手指按住collectionView的位置
    fileprivate var fingerLocation: CGPoint!
    
    /// 手指开始长按时对应的IndexPath,可能为nil
    fileprivate var originalIndexPath: IndexPath?
    
    /// 手指移动时对应的IndexPath,可能为nil
    fileprivate var relocatedIndexPath: IndexPath?
    
    /// 截屏View
    fileprivate var snapshot: UIView?
    
    /// 是否进入编辑状态
    fileprivate var isEdit: Bool = false
    
    fileprivate lazy var collectionDatas: Array = { [
        ["推荐", "热点", "视频", "问答", "体育", "历史", "科技", "健康", "娱乐", "时尚", "故事", "直播", "数码", "辟谣", "养生"],
        ["美图", "正能量", "搞笑", "文化", "小说", "语录", "深圳", "社会", "汽车", "财经", "军事", "段子", "美女", "国际", "趣图", "特卖", "房产", "育儿", "美食", "电影"]
        ] }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(rightItemClick(_:)))
        
        // 设置layout
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 8
        let itemW = (view.bounds.width - margin * 5) / 4
        let itemH: CGFloat = 48
        layout.itemSize = CGSize(width: itemW, height: itemH)
        // 最小行间距
        layout.minimumLineSpacing = margin
        // 最小item之间的距离
        layout.minimumInteritemSpacing = margin
        // 每组item的边缘切距
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 15, right: margin)
        // 头部视图的大小
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        collectionView?.collectionViewLayout = layout
                
        // 注册cell和头部视图
        self.collectionView!.register(UINib.init(nibName: "MoveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "MoveHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        // 给collectionView添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        collectionView?.addGestureRecognizer(longPress)
        
        // 给collectionView添加滑动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        panGesture.delegate = self;
        collectionView?.addGestureRecognizer(panGesture)
    }
    
    // MARK: Events
    
    @objc func rightItemClick(_ item: UIBarButtonItem) {
        if navigationItem.rightBarButtonItem?.title == "编辑" {
            navigationItem.rightBarButtonItem?.title = "完成"
            isEdit = true
            collectionView?.reloadSections([0])
        } else {
            navigationItem.rightBarButtonItem?.title = "编辑"
            isEdit = false
            collectionView?.reloadSections([0])
        }
    }
    
    /// 给collectionView添加pan手势
    @objc func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        guard self.isEdit else { return }
        handleGesture(sender)
    }
    
    /// 给collectionView添加长按手势
    @objc func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        handleGesture(sender)
    }

    
    // MARK: - Help Methods
    
    /// 处理长按和滑动时候的手势
    ///
    /// - Parameter sender: 手势
    func handleGesture(_ sender: UIGestureRecognizer) {
        let senderState = sender.state
        // 手指在collectionView中的位置
        fingerLocation = sender.location(in: collectionView)
        // 手指按住位置对应的indexPath,可能为nil
        relocatedIndexPath = collectionView?.indexPathForItem(at: fingerLocation)
        
        switch senderState {
        case .began:
            originalIndexPath = collectionView?.indexPathForItem(at: fingerLocation)
            guard let letOriginalIndexPath = originalIndexPath, originalIndexPath?.section == 0, snapshot == nil else {
                return
            }
            // 如果还没进入编辑状态，就让他进入编辑状态，cell同时显示移除按钮
            if !isEdit {
                isEdit = true
                navigationItem.rightBarButtonItem?.title = "完成"
                // 这里不用刷新，是因为如果刷新，进不能根据indexpath 找到cell
                for i in 0 ..< collectionDatas[0].count {
                    let index = IndexPath(item: i, section: 0)
                    let cell = collectionView?.cellForItem(at: index) as! MoveCollectionViewCell
                    cell.begainAnimation()
                    cell.removeBtn.isHidden = false
                }
            }
            cellSelectedAtIndexPath(letOriginalIndexPath)
        case .changed:
            guard snapshot != nil, originalIndexPath != nil else { return }
            
            // 移动cell
            var center = snapshot!.center
            center.y = fingerLocation.y
            center.x = fingerLocation.x
            snapshot!.center = center
            
            // 判断是否进入了其它cell的范围, 并且不是第二个sections
            guard let letrelocatedIndexPath = relocatedIndexPath, relocatedIndexPath != originalIndexPath, relocatedIndexPath?.section == 0 else {
                return
            }
            // 进行排序
            cellRelocatedToNewIndexPath(letrelocatedIndexPath)
            
        case .ended:
            guard let letOriginalIndexPath = originalIndexPath, snapshot != nil else {
                return
            }
            let attributes =  collectionView?.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1))
            // 如果在第二组的位置，让它移动到第二组
            if fingerLocation.y > attributes!.frame.maxY {
                collectionView?.performBatchUpdates({
                    self.betweenSectionsMoveCell(with: letOriginalIndexPath)
                }, completion: { (_) in
                    // self.collectionView?.reloadData()
                    self.didEndDraging()
                    
                })
            } else {
                didEndDraging()
            }
            
        default:
            break
        }
    }
    
    
    /// 在不同sections之间的cell移动
    ///
    /// - Parameter indexPath: 需要移动indexPath
    func betweenSectionsMoveCell(with indexPath: IndexPath) {
        let obj = self.collectionDatas[indexPath.section][indexPath.item]
        self.collectionDatas[indexPath.section].remove(at: indexPath.item)
        var anotherIndexPath = IndexPath(item: 0, section: 1)
        if indexPath.section == 1 {
            anotherIndexPath = IndexPath(item: self.collectionDatas[0].count, section: 0)
        }
        self.collectionDatas[anotherIndexPath.section].insert(obj, at: anotherIndexPath.item)
        self.collectionView?.moveItem(at: indexPath, to: anotherIndexPath)
        originalIndexPath = anotherIndexPath;
    }
    
    /// 拖动结束，显示cell,并移除截图
    func didEndDraging() {
        guard let letoriginalIndexPath = originalIndexPath else { return }
        let cell = collectionView?.cellForItem(at: letoriginalIndexPath) as? MoveCollectionViewCell
        cell?.isHidden = false
        cell?.alpha = 0
        UIView.animate(withDuration: 0.2, animations: { 
            self.snapshot!.center = cell!.center
            self.snapshot!.alpha = 0
            self.snapshot!.transform = .identity
            cell?.alpha = 1
            if letoriginalIndexPath.section == 1 {
                cell?.removeBtn.isHidden = true
                cell?.stopAnimation()
            }
        }) { (_) in
            self.snapshot!.removeFromSuperview()
            self.snapshot = nil
            self.originalIndexPath = nil
            self.relocatedIndexPath = nil
        }
        
    }
    
    /// 移动cell,并更新数据源
    func cellRelocatedToNewIndexPath(_ indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            // 移动的时候更新数据源
            let obj = collectionDatas[0][originalIndexPath!.item]
            collectionDatas[0].remove(at: originalIndexPath!.item)
            collectionDatas[0].insert(obj, at: indexPath.item)
            
            collectionView?.moveItem(at: originalIndexPath!, to: indexPath)
            
            //更新cell的原始indexPath为当前indexPath
            originalIndexPath = indexPath;
        }
    }
    
    /// 隐藏cell, 并显示截图
    func cellSelectedAtIndexPath(_ indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        snapshot = customSnapshotFromView(cell!)
        collectionView?.addSubview(snapshot!)
        cell?.isHidden = true
        var center = snapshot!.center
        center.y = fingerLocation.y
        UIView.animate(withDuration: 0.2) { 
            self.snapshot!.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
            self.snapshot!.alpha = 0.98
            self.snapshot!.center = center
        }
    }
    
    
    /// 返回一个截图
    func customSnapshotFromView(_ inputView: UIView) -> UIView {
        // 生成一张图片
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 生成View
        let snapshot = UIImageView(image: image)
        snapshot.center = inputView.center
        snapshot.alpha = 0.6
        snapshot.layer.masksToBounds = true
        snapshot.layer.cornerRadius = 0.0
        return snapshot
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MoveCollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let sender = gestureRecognizer as! UIPanGestureRecognizer
        let trnslationPoint = sender.translation(in: collectionView)
        // 结束动画有时间，扫的手势很容易出问题，需要保证 snapshot == nil,才让它开始，pan手势结束和开始可能会特别快，需要格外留心，为了保证pan手势不影响collectionView的竖直滑动，竖直方向偏移不让它开始
        if abs(trnslationPoint.x) > 0.2  && snapshot == nil {
            return true
        }
        return false
    }
}

// MARK: - UICollectionViewDelegate
extension MoveCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionDatas.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDatas[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MoveCollectionViewCell
        cell.titleLabel.text = collectionDatas[indexPath.section][indexPath.item]
        
        /// 进入编辑状态，第一组显示删除
        if isEdit && indexPath.section == 0 {
            cell.removeBtn.isHidden = false
            cell.begainAnimation()
        } else {
            cell.removeBtn.isHidden = true
        }
        return cell
    }
    
    /// 头部视图
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headReuseView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! MoveHeaderCollectionReusableView
        if indexPath.section == 0 {
            headReuseView.titleLabel.text = "我的频道"
            headReuseView.detaiLabel.text = "拖拽可以排序"
        } else {
            headReuseView.titleLabel.text = "频道推荐"
            headReuseView.detaiLabel.text = "点击添加频道"
        }
        return headReuseView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 如果不是编辑状态，不需要
        if !isEdit && indexPath.section == 0 {
            return
        }
        
        /// 先移动数据， 后刷新
        collectionView.performBatchUpdates({
            self.betweenSectionsMoveCell(with: indexPath)
        }, completion: { (_) in
            collectionView.reloadItems(at: [self.originalIndexPath!])
        })
    }
}
