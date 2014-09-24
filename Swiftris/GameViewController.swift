//
//  GameViewController.swift
//  Swiftris
//
//  Created by Paulo Silva on 22/09/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
  
  var scene: GameScene!
  var swiftris:Swiftris!
  
  var panPointReference:CGPoint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure the view.
    let skView = view as SKView
    skView.multipleTouchEnabled = false
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    
    scene.tick = didTick
    
    swiftris = Swiftris()
    swiftris.delegate = self
    swiftris.beginGame()
    
    // Present the scene.
    skView.presentScene(scene)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  @IBAction func didPan(sender: UIPanGestureRecognizer) {
    let currentPoint = sender.translationInView(self.view)
    
    if let originalPoint = panPointReference {
      if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
        if sender.velocityInView(self.view).x > CGFloat(0) {
          swiftris.moveShapeRight()
          panPointReference = currentPoint
        } else {
          swiftris.moveShapeLeft()
          panPointReference = currentPoint
        }
      }
    } else if sender.state == .Began {
      panPointReference = currentPoint
    }
  }
  
  @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
    swiftris.dropShape()
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
    return true
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
    if let swipeRec = gestureRecognizer as? UISwipeGestureRecognizer {
      if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
        return true
      }
    } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
      if let tapRec = otherGestureRecognizer as? UITapGestureRecognizer {
        return true
      }
    }
    return false
  }
  
  @IBAction func didTap(sender: UITapGestureRecognizer) {
    swiftris.rotateShape()
  }
  
  func didTick() {
    swiftris.letShapeFall()
  }
  
  func nextShape() {
    let newShapes = swiftris.newShape()
    
    if let fallingShape = newShapes.fallingShape {
      self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
      self.scene.movePreviewShape(fallingShape) {
        self.view.userInteractionEnabled = true
        self.scene.startTicking()
      }
    }
  }
  
  func gameDidBegin(swiftris: Swiftris) {
    // The following is false when restarting a new game
    if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
      scene.addPreviewShapeToScene(swiftris.nextShape!) {
        self.nextShape()
      }
    } else {
      nextShape()
    }
  }
  
  func gameDidEnd(swiftris: Swiftris) {
    view.userInteractionEnabled = false
    scene.stopTicking()
  }
  
  func gameDidLevelUp(swiftris: Swiftris) {
    
  }
  
  func gameShapeDidDrop(swiftris: Swiftris) {
    scene.stopTicking()
    scene.redrawShape(swiftris.fallingShape!) {
      swiftris.letShapeFall()
    }
  }
  
  func gameShapeDidLand(swiftris: Swiftris) {
    scene.stopTicking()
    nextShape()
  }
  
  func gameShapeDidMove(swiftris: Swiftris) {
    scene.redrawShape(swiftris.fallingShape!) {}
  }
}
