//
//  EarthNode.swift
//  RealWorld
//
//  Created by Florian on 27/07/2018.
//  Copyright © 2018 Florian. All rights reserved.
//

import SceneKit


class EarthNode: SCNNode {
    
    override init() {
        super.init()
        
        self.geometry = SCNSphere(radius: 0.1)
        //self.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        var arrayOfColors = [UIColor.red, UIColor.yellow, UIColor.blue]
        let randomColor = arc4random() % UInt32(arrayOfColors.count)
        let color = arrayOfColors[Int(randomColor)]
       // material?.diffuse.contents = color
        
        let material = self.geometry?.firstMaterial
        
        material?.lightingModel = .physicallyBased
        
        material?.shininess = 75
        material?.metalness.contents = 1.0
        material?.roughness.contents = 0
        
        //material?.reflective.contents = UIImage(named: "art.scnassets/reflection.jpg")
        //material?.diffuse.contents = UIImage(named: "art.scnassets/albedo.png")
        material?.diffuse.contents = UIImage(named: "art.scnassets/BeachBallColor.jpg")
        //material?.roughness.contents = UIImage(named: "art.scnassets/roughness.png")
        //material?.metalness.contents = UIImage(named: "art.scnassets/metalness.png")
        //material?.normal.contents = UIImage(named: "art.scnassets/normal.png")

        //self.physicsBody = SCNPhysicsBody(type: .dynamic,shape: nil);
        
        let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 8)
        let repeatAction = SCNAction.repeatForever(action)
        self.runAction(repeatAction)
        
        let moveLeft = SCNAction.moveBy(x: 0.18, y: 0, z: 0, duration: 1)
        moveLeft.timingMode = .easeInEaseOut;
        let moveRight = SCNAction.moveBy(x: -0.18, y: 0, z: 0, duration: 1)
        moveRight.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveLeft, moveRight])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        self.runAction(moveLoop)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
    }

}
