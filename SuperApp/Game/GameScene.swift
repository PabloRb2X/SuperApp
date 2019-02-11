//
//  GameScene.swift
//  FlappyFly
//
//  Created by Pablo Ramirez Barrientos on 08/11/18.
//  Copyright © 2018 Pablo Ramirez Barrientos. All rights reserved.
//

import SpriteKit
import GameplayKit

/*protocol GameViewDelegate {
    func returnToMenu()
}*/

class GameScene: SKScene, SKPhysicsContactDelegate, ButtonDelegate {
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
    var fly: SKSpriteNode! /// mosca
    var pipeUp: SKSpriteNode!
    var pipeDown: SKSpriteNode!
    
    var scoreLabel: SKLabelNode = SKLabelNode()//(fontNamed: "04B_19__")
    
    enum nodeType: UInt32{
        case FLY = 1
        case PIPE_AND_FLOOR = 2
        case SPACE_BETWEEN_PIPES = 4
    }
    
    var randomDistanceBetweenPipes: CGFloat = 0
    var extraDistance: CGFloat = 0
    
    var timer = Timer()
    var gameOver = false
    var points = 0
    
    //var gameViewDelegate: GameViewDelegate!
    var controllerReference: GameViewController!
    
    private var button = Button()
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
/*
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
*/
        self.physicsWorld.contactDelegate = self
        
        randomDistanceBetweenPipes = CGFloat(arc4random() % UInt32(self.frame.height / 2))
        extraDistance = randomDistanceBetweenPipes - self.frame.height / 4
        
        initScene()
    }
    
    func initScene(){
        
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(addPipes), userInfo: nil, repeats: true)
        
        /// Scrolling
        var i: CGFloat = 0
        while i < 3 {
            let background: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "fondo.png"))
            background.position = CGPoint(x: (background.texture?.size().width)! * i, y: self.frame.midY)
            background.size.height = self.frame.height
            background.zPosition = 0
            background.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.move(by: CGVector(dx: -(background.texture?.size().width)!, dy: 0), duration: 4),
                SKAction.move(by: CGVector(dx:  (background.texture?.size().width)!, dy: 0), duration: 0)]
            )))
            self.addChild(background)
            
            i += 1
        }
        
        fly = SKSpriteNode(texture: SKTexture(imageNamed: "fly1.png"))
        fly.position = CGPoint(x: 0.0, y: 0.0)
        fly.zPosition = 1
        fly.physicsBody = SKPhysicsBody(circleOfRadius: (fly.texture?.size().width)! / 2)
        fly.physicsBody?.isDynamic = false
        fly.physicsBody?.categoryBitMask = nodeType.FLY.rawValue //// Tipo de colision
        fly.physicsBody?.collisionBitMask = nodeType.PIPE_AND_FLOOR.rawValue /// objetos con los que puede colisionar
        fly.physicsBody?.contactTestBitMask = nodeType.PIPE_AND_FLOOR.rawValue | nodeType.SPACE_BETWEEN_PIPES.rawValue
        fly.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "fly1.png"), SKTexture(imageNamed: "fly2.png")], timePerFrame: 0.05)))
        self.addChild(fly)
        
        /// Dead Sensor
        let floor = SKNode()
        floor.position = CGPoint(x: -self.frame.width / 2, y: -self.frame.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        floor.physicsBody?.isDynamic = false /// No lo afecta la gravedad
        floor.physicsBody?.categoryBitMask = nodeType.PIPE_AND_FLOOR.rawValue
        floor.physicsBody?.collisionBitMask = nodeType.FLY.rawValue
        floor.physicsBody?.contactTestBitMask = nodeType.FLY.rawValue
        self.addChild(floor)
        
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 80
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.4)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        
    }
    
     @objc func addPipes(){
        /// Numero aleatorio entre cero y la mitad de la pantalla
        let randomDistanceBetweenPipes = CGFloat(arc4random() % UInt32(self.frame.height / 2))
        let extraDistance = randomDistanceBetweenPipes - self.frame.height / 4
        
        pipeUp = SKSpriteNode(texture: SKTexture(imageNamed: "Tubo1.png"))
        pipeUp.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + (pipeUp.texture?.size().height)! / 2 + fly.size.height * 3 + extraDistance)
        pipeUp.zPosition = 1
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: (pipeUp.texture?.size())!)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = nodeType.PIPE_AND_FLOOR.rawValue
        pipeUp.physicsBody?.collisionBitMask = nodeType.FLY.rawValue
        pipeUp.physicsBody?.contactTestBitMask = nodeType.FLY.rawValue
        self.addChild(pipeUp)
        
        pipeDown = SKSpriteNode(texture: SKTexture(imageNamed: "Tubo2.png"))
        pipeDown.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - (pipeUp.texture?.size().height)! / 2 - fly.size.height * 3 + extraDistance)
        pipeDown.zPosition = 1
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: (pipeDown.texture?.size())!)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = nodeType.PIPE_AND_FLOOR.rawValue
        pipeDown.physicsBody?.collisionBitMask = nodeType.FLY.rawValue
        pipeDown.physicsBody?.contactTestBitMask = nodeType.FLY.rawValue
        self.addChild(pipeDown)
        
        let pipesMove = SKAction.sequence([SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 80)), SKAction.removeFromParent()])
        
        pipeUp.run(pipesMove)
        pipeDown.run(pipesMove)
        
        let space = SKNode()
        space.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + extraDistance)
        space.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: SKTexture(imageNamed: "Tubo1").size().width, height: fly.size.height * 3))
        space.physicsBody?.isDynamic = false
        space.zPosition = 1
        space.physicsBody?.categoryBitMask = nodeType.SPACE_BETWEEN_PIPES.rawValue
        space.physicsBody?.collisionBitMask = 0 /// no colisiona con nada
        space.physicsBody?.contactTestBitMask = nodeType.FLY.rawValue
        space.run(SKAction.sequence([SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 80)), SKAction.removeFromParent()]))
        self.addChild(space)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }*/
        
        if !gameOver{
            fly.physicsBody?.isDynamic = true
            fly.physicsBody?.velocity = CGVector(dx: 0, dy: 0) /// velocidad constante de caida
            fly.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
        else{
            gameOver = false
            scoreLabel.text = ""
            self.speed = 1
            self.removeAllChildren()
            
            initScene()
        }
        
        
        
    }
    
    ///// Delegado para detectar las colisiones entre objetos
    func didBegin(_ contact: SKPhysicsContact) {
        print("colisionando")
        
        if (contact.bodyA.categoryBitMask == nodeType.FLY.rawValue && contact.bodyB.categoryBitMask == nodeType.SPACE_BETWEEN_PIPES.rawValue) || (contact.bodyA.categoryBitMask == nodeType.SPACE_BETWEEN_PIPES.rawValue && contact.bodyB.categoryBitMask == nodeType.FLY.rawValue){
            
            print("colisionando mosca con espacio vacío")
            updateScore()
        }
        else{
            gameOver = true
            
            self.speed = 0
            timer.invalidate()
            
            scoreLabel.text = "Game Over"
            
            let button = Button(texture: nil, color: .magenta, size: CGSize(width: self.frame.width * 0.3, height: self.frame.height * 0.05))
            button.color = UIColor.blue
            button.name = "Regresar"
            button.position = CGPoint(x: 0, y: -self.frame.height * 0.43)
            button.zPosition = 2
            button.delegate = self
            
            self.addChild(button)
        }
    }
    
/*
    func touchDown(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
         n.position = pos
         n.strokeColor = SKColor.green
         self.addChild(n)
         }*/
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
         n.position = pos
         n.strokeColor = SKColor.blue
         self.addChild(n)
         }*/
    }
    
    func touchUp(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
         n.position = pos
         n.strokeColor = SKColor.red
         self.addChild(n)
         }*/
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
*/
    
    
    func updateScore(){
        points += 1
        scoreLabel.text = "\(points)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func buttonClicked(sender: Button) {
        print("you clicked the button named \(sender.name!)")
        
        //gameViewDelegate.returnToMenu()
        controllerReference.returnToMenu()
    }
}
