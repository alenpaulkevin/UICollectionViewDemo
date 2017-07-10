//
//  PrefecthingCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by CaoXuan on 2017/7/9.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit
import Kingfisher


private let reuseIdentifier = "Cell"

class PrefecthingCollectionViewController: UICollectionViewController {
    
    fileprivate var dataArray = ["http://img.jiaodong.net/pic/0/10/95/81/10958118_604510.jpg",
        "http://i01.pic.sogou.com/47907287c1f7d45b",
        "http://i01.pic.sogou.com/c61c287fc43cb6bf",
        "http://i03.pictn.sogoucdn.com/a3922ed43d6d7027",
        "http://i01.pictn.sogoucdn.com/400a032e4c831fb1",
        "http://i03.pictn.sogoucdn.com/64a055f3497f295f",
        "http://i04.pictn.sogoucdn.com/40778a743abae44a",
        "http://i02.pictn.sogoucdn.com/a20381b4283dc77d",
        "http://i01.pictn.sogoucdn.com/4120d236bb1627b3",
        "http://i04.pic.sogou.com/8a7ab42259a7778e",
        "http://i04.pic.sogou.com/d0cc38f5775ae2dc",
        "http://sports.sun0769.com/photo/composite/201303/W020130331542966530065.jpg",
        "http://ztd00.photos.bdimg.com/ztd/w=350;q=70/sign=1d1c9b312f2dd42a5f0907ae33002a88/fd039245d688d43f4da25faa771ed21b0ef43b5b.jpg"
        ,
        "http://i02.pictn.sogoucdn.com/f0da5d1d2e399f54",
        "http://www.manjpg.com/uploads/allimg/140712/628-140G2151G3.jpg",
        "http://b.hiphotos.baidu.com/zhidao/pic/item/3b292df5e0fe992535a1545f3ca85edf8db1710b.jpg"
        ,
        "http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=a2e684445b82b2b7a7ca31c2019de7d7/622762d0f703918fa34e218a533d269758eec4d6.jpg",
        "http://www.laonanren.cc/uploads/allimg/160215/3-1602151642164A.jpg",
        "http://img3.duitang.com/uploads/item/201501/01/20150101084426_sVcze.jpeg",
        "http://pic22.photophoto.cn/20120113/0036036771604425_b.jpg",
        "http://i04.pictn.sogoucdn.com/473008194fe06391",
        "http://upload.mnw.cn/2014/1030/1414658148257.jpg",
        "http://img5.duitang.com/uploads/item/201502/23/20150223111936_XH3m8.jpeg",
        "http://i01.pictn.sogoucdn.com/6e7a1bfdcb65926b"
                                 ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置layout
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 8
        let itemW = (view.bounds.width - margin * 2) / 1
        let itemH: CGFloat = itemW
        layout.itemSize = CGSize(width: itemW, height: itemH)
        // 最小行间距
        layout.minimumLineSpacing = margin
        // 最小item之间的距离
        layout.minimumInteritemSpacing = margin
        // 每组item的边缘切距
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 15, margin)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = .white
        
        
        // 注册cell和头部视图
        self.collectionView!.register(UINib.init(nibName: "PrefectchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        if #available(iOS 10.0, *) {
            // 设置代理
            self.collectionView?.prefetchDataSource = self
            // iOS 10的预加载跟iOS9,不一样，如果要跟iOS 9 一样，需要主动设置它为false,默认为true
//             collectionView?.isPrefetchingEnabled = false
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清除缓存", style: .done, target: self, action: #selector(clearCache))

    }
    
    func clearCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let url = URL(string: dataArray[indexPath.item])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PrefectchCollectionViewCell
        cell.backgroundColor = .lightGray
        
        cell.iconImageView.kf.setImage(with: url)
        return cell
    }
}
/*

 */

extension PrefecthingCollectionViewController: UICollectionViewDataSourcePrefetching {
    // 预加载，每次都会领先基本一页的数据
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.flatMap {
            URL(string: dataArray[$0.item])
        }
        // 开始下载
        ImagePrefetcher(urls: urls).start()
    }

    // 取消预加载，会在快速滑动还没停下来时，突然往相反方向快速滑动调用，当它调用， 程序也基本不会走cellForItemAt 方法， 直接走 willDisplaycell方法
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.flatMap {
            URL(string: dataArray[$0.item])
        }
        // 取消下载
        ImagePrefetcher(urls: urls).stop()
    }
}
