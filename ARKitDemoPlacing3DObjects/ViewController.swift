//
//  ViewController.swift
//  AugemntedRealWorld
//
//  Created by Florian on 27/07/2018.
//  Copyright © 2018 Florian. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planeGeometry:SCNPlane!
    let planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]() //Real world positions
    var sceneLight:SCNLight!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.automaticallyUpdatesLighting = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Setup Image Based Lighting (IBL) map
        let env = UIImage(named: "art.scnassets/sphericalStreet.jpg")
        scene.lightingEnvironment.contents = env
        scene.lightingEnvironment.intensity = 2.0
        
        let background = UIImage(named: "art.scnassets/sphericalBlurred.jpg")
        scene.background.contents = background;
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
            lightNode.light = sceneLight
            lightNode.position = SCNVector3(x:-5,y:10,z:2)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        let lightNode2 = SCNNode()
        lightNode2.light = sceneLight
        lightNode2.position = SCNVector3(x:5,y:10,z:-2)
        
        sceneView.scene.rootNode.addChildNode(lightNode2)
        
       
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
            configuration.planeDetection = .horizontal
            configuration.isLightEstimationEnabled = true
        
            // Enable automatic environment texturing (This is just AWESOME)
            //ARKit 2 required :(
            //configuration.EnvironmentTexturing = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        
        //Only on detected planes
        //addNodeAtLocation(location: location!)
        
        //Somewhere in space
        let hitResults = sceneView.hitTest(location! , types: .featurePoint)
        
        if let hitTestResult = hitResults.first {
            let transform = hitTestResult.worldTransform
            let position = SCNVector3(x: transform.columns.3.x, y: transform.columns.3.y, z: transform.columns.3.z)
        
        let newEarth = EarthNode()
            newEarth.position = position
        sceneView.scene.rootNode.addChildNode(newEarth)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:SCNNode?
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0)
            //planeGeometry.firstMaterial?.fillMode = .lines
            
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            updateMaterial()
            
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor) {
                if node.childNodes.count > 0 {
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
                    
                    if let plane = planeNode.geometry as? SCNPlane {
                        
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
                        
                        updateMaterial()
                        
                        //Extend the physical body as well
                        planeNode.physicsBody = SCNPhysicsBody(
                            type: .kinematic,
                            shape: SCNPhysicsShape(geometry: planeGeometry, options: nil));
                    }
                }
            }
        }
    }
    
    func addNodeAtLocation (location:CGPoint) {
        guard anchors.count > 0 else {print("anchros are not created yet"); return}
        
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if hitResults.count > 0 {
            let result = hitResults.first!
            let newLocation = SCNVector3(x: result.worldTransform.columns.3.x, y: result.worldTransform.columns.3.y + 0.5, z: result.worldTransform.columns.3.z)
            let earthNode = EarthNode()
            earthNode.position = newLocation
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
        
        
    }
    
    func updateMaterial() {
        let material = self.planeGeometry.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
