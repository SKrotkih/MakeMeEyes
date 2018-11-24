//
//  WinterHatScene.swift
//  MasterFace
//
//  Created by Сергей Кротких on 24/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

import Foundation
import SceneKit

class WinterHat {
    
    func configureScene() {
        
    }
    
    private func extractRootNode() -> SCNNode? {
        guard let shipScene = SCNScene(named: "HatwithFur.dae", inDirectory: "Whinter_Hat/", options: nil) else {
            return nil
        }
        let shipNode = SCNNode()
        let shipSceneChildNodes = shipScene.rootNode.childNodes
        for childNode in shipSceneChildNodes {
            shipNode.addChildNode(childNode)
        }
        return shipNode
    }
    
    
}
