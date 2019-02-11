//
//  MainController.swift
//  FlappyFly
//
//  Created by Pablo Ramirez Barrientos on 13/11/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import UIKit

class MainController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let mainView: MainView = MainView()
    var collectionView: UICollectionView!
    
    let cellTitles = ["Sprite Kit Game", "Realm", "PokeAPI (Alamofire)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initController(){
        
        self.title = "My app"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        self.view = mainView.initView(view: self.view)
        collectionView = mainView.collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: "CellID")
        
    }
    
    // MARK: - CollectionViewDelegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath as IndexPath) as! MainViewCell
        
        cell.initCell(indexPath: indexPath, titleText: cellTitles[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("game sprite kit")
            let controller: UIViewController = GameViewController()
            self.present(controller, animated: true, completion: nil)
        case 1:
            let controller: UIViewController = TasksListController()
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
