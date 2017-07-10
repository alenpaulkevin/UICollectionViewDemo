//
//  ViewController.swift
//  UICollectionViewDemo
//
//  Created by alenpaulkevin on 2017/6/19.
//  Copyright © 2017年 alenpaulkevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let data: [[String: Any]] = [
        ["text": "基本使用", "class": "BaseCollectionViewController"],
        ["text": "瀑布流", "class": "WaterFlowViewController"],
        ["text": "每页多个Cell水平滚动布局", "class": "HorizontalCollectionViewController"],
        ["text": "CoverFlow效果", "class": "CoverFlowViewController"],
        ["text": "轮转卡片", "class": "CircularCollectionViewController"],
        ["text": "模仿今日头条实现Cell重排", "class": "MoveCollectionViewController"],
        ["text": "iOS9用系统属性实现Cell重排", "class": "InteractiveMoveViewController"],
        ["text": "iOS10预加载", "class": "PrefecthingCollectionViewController"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /// 类文件字符串转换为ViewController
    ///
    /// - Parameter childControllerName: VC的字符串
    /// - Returns: ViewController
    func convertController(_ childControllerName: String) -> UIViewController? {
        
        // 1.获取命名空间
        // 通过字典的键来取值,如果键名不存在,那么取出来的值有可能就为没值.所以通过字典取出的值的类型为AnyObject?
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return nil
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            return nil
        }
        
        if clsType is UICollectionViewController.Type {
            let coll = clsType as! UICollectionViewController.Type
            let collCls = coll.init(collectionViewLayout: CircularCollectionViewLayout())
            return collCls
        }
        
        // 3.通过Class创建对象
        let childController = clsType.init()
        
        return childController
    }
}

// MARK: - 代理
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]["text"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let className = data[indexPath.row]["class"] as! String
        let cls = convertController(className)!
        navigationController?.pushViewController(cls, animated: true)
    }
}

