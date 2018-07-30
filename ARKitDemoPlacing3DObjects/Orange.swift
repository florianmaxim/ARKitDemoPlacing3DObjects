//
//  Orange.swift
//  AugemntedRealWorld
//
//  Created by Florian on 27/07/2018.
//  Copyright © 2018 Florian. All rights reserved.
//

import ARKit

class SpaceShip: SCNNode {
    
    func loadModal() {
        guard let virtualOjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualOjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
    }
    
}
