//
//  DraggableImageView.swift
//  draggableCard
//
//  Created by 山口智生 on 2016/02/13.
//  Copyright © 2016年 ha1f. All rights reserved.
//

import UIKit

@objc
protocol DraggableViewFieldDelegate {
    func transformForRelativePosition(relativePosition: CGPoint) -> CGAffineTransform
    
    optional func onSubviewTouched(view: UIView)
}

extension DraggableViewField: DraggableViewFieldDelegate {
    func transformForRelativePosition(relativePosition: CGPoint) -> CGAffineTransform {
        return CGAffineTransformMakeRotation(-relativePosition.x/800)
    }
}

class DraggableViewField: UIView {
    
    var delegate: DraggableViewFieldDelegate?
    
    var isDragging: Bool {
        if let _ = touchStartPoint {
            return true
        }
        return false
    }
    
    private static func addVector(point: CGPoint, point2: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + point2.x, y: point.y + point2.y)
    }
    
    private static func diffVector(from: CGPoint, to: CGPoint) -> CGPoint {
        return CGPoint(x: to.x - from.x, y: to.y - from.y)
    }
    
    private var touchStartPoint: CGPoint? = nil
    private var draggingCard: UIView? = nil
    private var originCardPosition: CGPoint? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        self.clipsToBounds = true
        self.multipleTouchEnabled = false
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            startDragging(touch)
        }
    }
    
    func startDragging(touch: UITouch) {
        // 上にあるものから順に検査
        for card in self.subviews.filter({$0.userInteractionEnabled == false}).reverse() {
            if card.frame.contains(touch.locationInView(self)) {
                touchStartPoint = touch.locationInView(self)
                draggingCard = card
                originCardPosition = card.layer.position
                
                delegate?.onSubviewTouched?(card)
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let card = draggingCard, let position = originCardPosition {
            UIView.animateWithDuration(0.5) {
                card.layer.position = position
                card.transform = CGAffineTransformMakeRotation(0)
            }
            draggingCard = nil
            originCardPosition = nil
        }
        touchStartPoint = nil
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // 外側ならタッチ終了させる
            guard self.bounds.contains(touch.locationInView(self)) else {
                self.touchesEnded(Set(), withEvent: nil)
                return
            }
            if let startTouchPoint = touchStartPoint, let card = draggingCard, let originCardPosition = originCardPosition {
                let touchPoint = touch.locationInView(self)

                let vect = DraggableViewField.diffVector(startTouchPoint, to: touchPoint)
                card.layer.position = DraggableViewField.addVector(originCardPosition, point2: vect)
                card.transform = delegate?.transformForRelativePosition(vect) ?? CGAffineTransformMakeRotation(0)
            } else {
                startDragging(touch)
            }
        }
    }
}