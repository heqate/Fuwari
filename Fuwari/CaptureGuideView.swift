//
//  CaptureGuideView.swift
//  Fuwari
//
//  Created by Kengo Yokoyama on 2016/12/05.
//  Copyright © 2016年 AppKnop. All rights reserved.
//

import Cocoa

class CaptureGuideView: NSView {

    var startPoint = NSPoint.zero {
        didSet {
            needsDisplay = true
        }
    }
    
    var cursorPoint = NSPoint.zero {
        didSet {
            needsDisplay = true
        }
    }
    
    var guideWindowRect = NSRect.zero
    
    private let cursorFont = NSFont.systemFont(ofSize: 10.0)
    private let cursorSize = CGFloat(25.0)
    private let cursorGuideWidth = CGFloat(1.0)
    private lazy var coordinateLabelShadow: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        shadow.shadowOffset = NSSize(width: 1, height: -1)
        return shadow
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.clear.set()
        NSRectFill(frame)
        
        drawCaptureArea()
        drawCursorPosition()
    }

    override func mouseEntered(with event: NSEvent) {
        NSCursor.crosshair().push()
    }

    override func mouseExited(with event: NSEvent) {
        NSCursor.pop()
    }

    override func updateTrackingAreas() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }

    private func drawCaptureArea() {
        if startPoint != .zero {
            NSColor(red: 0, green: 0, blue: 0, alpha: 0.25).set()
            guideWindowRect = NSRect(x: fmin(startPoint.x, cursorPoint.x), y: fmin(startPoint.y, cursorPoint.y), width: fabs(cursorPoint.x - startPoint.x), height: fabs(cursorPoint.y - startPoint.y))
            NSRectFill(guideWindowRect)
            
            NSColor.white.set()
            NSFrameRectWithWidth(guideWindowRect, cursorGuideWidth)
        }
    }
    
    private func drawCursorPosition() {
        (Int(cursorPoint.x).description as NSString).draw(at: NSPoint(x: cursorPoint.x + cursorSize / 2, y: cursorPoint.y - cursorSize / 2), withAttributes: [NSFontAttributeName : cursorFont, NSShadowAttributeName : coordinateLabelShadow])
        (Int(frame.height - cursorPoint.y).description as NSString).draw(at: NSPoint(x: cursorPoint.x + cursorSize / 2, y: cursorPoint.y - cursorSize), withAttributes: [NSFontAttributeName : cursorFont, NSShadowAttributeName : coordinateLabelShadow])
    }
    
    func reset() {
        startPoint = .zero
        cursorPoint = .zero
        guideWindowRect = .zero
    }
}
