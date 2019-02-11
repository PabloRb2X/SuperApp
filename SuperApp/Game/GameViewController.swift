//
//  GameViewController.swift
//  FlappyFly
//
//  Created by Pablo Ramirez Barrientos on 08/11/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController{//, GameViewDelegate {

    var sceneInstance: SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView: SKView = SKView()
        skView.frame = self.view.bounds
        self.view.addSubview(skView)
        
        if let view = skView as SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                sceneInstance = scene
                (scene as! GameScene).controllerReference = self
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                //sceneInstance.delegate = self as? SKSceneDelegate
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func returnToMenu() {
        dismiss(animated: true, completion: nil)
    }
}
