//
//  PhysicsScene.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI
import SpriteKit

class PhysicsScene: SKScene {
    private let totalDrops = 50
    private let spawnInterval: TimeInterval = 5.0 / 50.0

    override init(size: CGSize) {
        super.init(size: size)
        scaleMode       = .resizeFill
        backgroundColor = .clear
        physicsBody     = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func startFalling() {
        let spawn = SKAction.run { [weak self] in self?.spawnImage() }
        let wait  = SKAction.wait(forDuration: spawnInterval)
        let seq   = SKAction.sequence([spawn, wait])
        run(SKAction.repeat(seq, count: totalDrops))
    }

    private func spawnImage() {
        let idx = 1
        let sprite = SKSpriteNode(imageNamed: "\(idx)")
        sprite.setScale(0.3)

        let x = CGFloat.random(in: sprite.size.width/2...size.width - sprite.size.width/2)
        let y = size.height - sprite.size.height/2
        sprite.position = CGPoint(x: x, y: y)

        let body = SKPhysicsBody(rectangleOf: sprite.size)
        body.affectedByGravity = true
        body.applyImpulse(CGVector(dx: CGFloat.random(in: -50...50), dy: 0))
        sprite.physicsBody = body

        addChild(sprite)
        run(SKAction.playSoundFileNamed("pop_sound.mp3", waitForCompletion: false))

    }

    func popAllSprites() {
        let pop = SKAction.group([
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
        ])

        for case let sprite as SKSpriteNode in children {
            let delay = SKAction.wait(forDuration: TimeInterval.random(in: 0...0.5))
            let seq = SKAction.sequence([delay, pop, .removeFromParent()])
            sprite.run(seq)
            run(SKAction.playSoundFileNamed("pop_sound.mp3", waitForCompletion: false))
        }
    }
}
