//
//  MainViewCell.swift
//  FlappyFly
//
//  Created by Pablo Ramirez Barrientos on 13/11/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import Foundation
import UIKit

class MainViewCell: UICollectionViewCell{
    
    func initCell(indexPath: IndexPath, titleText: String){
        //self.backgroundColor = UIColor.lightGray
        
        let title: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.8, height: self.frame.height))
        title.setTitle(titleText, for: .normal)
        title.setTitleColor(UIColor.black, for: .normal)
        title.titleLabel?.textAlignment = .left
        title.titleLabel?.font = UIFont(name: "Arial", size: 18)
        title.titleLabel?.numberOfLines = 1
        title.contentVerticalAlignment = .fill
        title.contentHorizontalAlignment = .left
        title.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width * 0.05, bottom: 0, right: 0)
        title.isUserInteractionEnabled = false
        self.addSubview(title)
        
        let line: UIView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
        line.backgroundColor = UIColor.gray
        self.addSubview(line)
    }
    
}
