//
//  DraggableImageView.swift
//  draggableCard
//
//  Created by 山口智生 on 2016/02/13.
//  Copyright © 2016年 ha1f. All rights reserved.
//

import UIKit

class DraggableImageView: UIView {
    
}

extension CGRect {
    func checkContain(point: CGPoint) -> Bool {
        if (point.x >= self.minX) && (point.x <= self.maxX) && (point.y >= self.minY) && (point.y <= self.maxY) {
            return true
        } else {
            return false
        }
    }
}

extension CGPoint {
    func vectTo(point: CGPoint) -> (x: CGFloat, y: CGFloat) {
        return (point.x - self.x, point.y - self.y)
    }
    
    func advancedBy(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

class DraggableImageViewField: UIView {
    
    var startTouchPoint: CGPoint? = nil
    var draggingCard: UIView? = nil
    var startCardPosition: CGPoint? = nil
    
    var cards: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.multipleTouchEnabled = false
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addCard(card: UIView) {
        self.addSubview(card)
        self.cards.append(card)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            startDragging(touch)
        }
    }
    
    func startDragging(touch: UITouch) {
        // 上にあるものから順に検査
        for card in cards.reverse() {
            if card.frame.contains(touch.locationInView(self)) {
                startTouchPoint = touch.locationInView(self)
                draggingCard = card
                startCardPosition = card.layer.position
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let card = draggingCard, let position = startCardPosition {
            UIView.animateWithDuration(0.5) {
                card.layer.position = position
                card.transform = CGAffineTransformMakeRotation(0)
            }
            draggingCard = nil
            startCardPosition = nil
        }
        startTouchPoint = nil
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            guard self.frame.contains(touch.locationInView(self)) else {
                self.touchesEnded(Set(), withEvent: nil)
                return
            }
            if let startTouchPoint = startTouchPoint, let card = draggingCard {
                let touchPoint = touch.locationInView(self)
                let vect = startTouchPoint.vectTo(touchPoint)
                card.layer.position = startCardPosition!.advancedBy(vect.x, y: vect.y)
                draggingCard?.transform = CGAffineTransformMakeRotation(-vect.x/800)
            } else {
                startDragging(touch)
            }
        }
    }
}