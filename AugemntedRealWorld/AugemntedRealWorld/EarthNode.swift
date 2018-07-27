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
        //self.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"Diffuse")
        self.geometry?.firstMaterial?.specular.contents = UIImage(named:"Specular")
        self.geometry?.firstMaterial?.emission.contents = UIImage(named:"Emission")
        self.geometry?.firstMaterial?.normal.contents = UIImage(named:"Normal")
        
        let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 8)
        
        let repeatAction = SCNAction.repeatForever(action)
        
        self.runAction(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
    }

}
