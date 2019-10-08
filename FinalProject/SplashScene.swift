//
//  SplashScene.swift
//  FinalProject
//
//  Created by William Nesham on 7/31/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import SpriteKit

class SplashScene: SKScene {
    
    var spriteSheet: SpriteSheet? = nil
    var spriteNode: SKSpriteNode? = nil
    
    override init() {
        super.init()
        
        spriteSheet=SpriteSheet(texture: SKTexture(imageNamed: "animeSprites"), rows: 3, columns: 3, spacing: 4, margin: 0)
        
        //Create 9 sprites from sheet
        var allSprites = [SKSpriteNode]()
        for row in 0...2 {
            for col in 0...2 {
                
                self.spriteNode = SKSpriteNode(texture: spriteSheet?.textureForColumn(column: col, row: row))
                self.anchorPoint = CGPoint(x:0.25 ,y:0.5 )
                if let spriteNode = self.spriteNode {
                    spriteNode.position = CGPoint.init(x: col*100, y: row*100)
                    allSprites.append(spriteNode)
                    spriteNode.isHidden = true
                    self.addChild(spriteNode)
                } else {
                    return
                }
            }
        }
//        var maxDuration:TimeInterval = 0
        let actions = allSprites.map { sprite in
            return SKAction.run {
                let randomNum: UInt32 = arc4random_uniform(5)
                let testNum: UInt32 = randomNum
//                let timeTillAppeared = TimeInterval(testNum / 10)
                let timeTillAppeared = TimeInterval(testNum)
                let wait = SKAction.wait(forDuration: timeTillAppeared)
                let show = SKAction.unhide()
                let sequence = SKAction.sequence([wait, show])
                sprite.run(sequence)
//                maxDuration += max(maxDuration, timeTillAppeared + 1)
                
            }
        }
//        let wait = SKAction.wait(forDuration: maxDuration)
//        let completion = SKAction.run {
//            print("All sprites have been set to appear. \(maxDuration)")
//        }
//        let sequence = SKAction.sequence([wait, completion])
//        let group = SKAction.group(actions + [sequence])
        let group = SKAction.group(actions)
        self.run(group)
        
        
    }
    
    override init(size:CGSize){
        super.init(size:size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    
}

