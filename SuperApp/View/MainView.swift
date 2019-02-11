//
//  MainView.swift
//  FlappyFly
//
//  Created by Pablo Ramirez Barrientos on 13/11/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewDelegate {
    
}

public class MainView: UIView{
    
    var view: UIView!
    //var mainViewDelegate: MainViewDelegate!
    
    var collectionView: UICollectionView!
    
    func initView(view: UIView) -> UIView{
        self.view = view
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        collectionView.tag = 100
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        return view
    }
}
