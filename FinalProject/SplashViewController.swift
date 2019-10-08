//
//  SplashViewController.swift
//  FinalProject
//
//  Created by William Nesham on 7/29/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import UIKit
import SpriteKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let scene = SplashScene()
        let spriteView = view as! SKView
        spriteView.showsFPS = true
        spriteView.showsFields = true
        spriteView.showsNodeCount = true
        spriteView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        spriteView.presentScene(scene)
        if spriteView.shouldCullNonVisibleNodes {
            performMySegue()
        }
    }
    
    func performMySegue() {
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        self.performSegue(withIdentifier: "startApp", sender: self)
        }
    }
}

