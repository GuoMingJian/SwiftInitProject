//
//  MJUnderLineButton.swift
//  AnyTrekForklift
//
//  Created by 郭明健 on 2023/3/1.
//

import UIKit

// MARK: - MJUnderLineButton (下划线按钮)
class MJUnderLineButton: MJEnlargeButton {
    /// 是否显示下划线
    public var isShowLine: Bool = true
    /// 下划线与text间距，默认2
    public var lineSpac: CGFloat = 2
    
    static func underlineButton(isShowLine: Bool,
                                lineSpac: CGFloat = 2) -> MJUnderLineButton {
        let button = MJUnderLineButton()
        button.isShowLine = isShowLine
        button.lineSpac = lineSpac
        return button
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if lineSpac < 2 {
            lineSpac = 2
        }
        var lineColor: UIColor = self.titleLabel?.textColor ?? .blue
        if !isShowLine {
            lineColor = .clear
        }
        guard let textRect = self.titleLabel?.frame,
              var descender = self.titleLabel?.font.descender,
              let context = UIGraphicsGetCurrentContext() else { return }
        //
        if descender < 0 {
            descender += 2.5
        }
        descender += lineSpac
        context.setStrokeColor(lineColor.cgColor)
        var point = CGPoint(x: textRect.origin.x, y: textRect.origin.y + textRect.size.height + descender)
        context.move(to: point)
        point = CGPoint(x: textRect.origin.x + textRect.size.width, y: textRect.origin.y + textRect.size.height + descender)
        context.addLine(to: point)
        context.closePath()
        context.drawPath(using: .stroke)
    }
}

// MARK: - MJEnlargeButton (扩大点击范围)
public class MJEnlargeButton: UIButton {
    
    /// 扩大点击区域
    public var enlargeInsets: UIEdgeInsets = .zero
    
    /// 上下左右均扩大该值的点击范围
    public var enlargeInset: CGFloat = 0 {
        didSet {
            let inset = max(0, enlargeInset)
            enlargeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard !isHidden, alpha != 0 else {
            return false
        }
        
        let rect = enlargeRect()
        if rect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }
    
    private func enlargeRect() -> CGRect {
        guard enlargeInsets != .zero else {
            return bounds
        }
        
        let rect = CGRect(
            x: bounds.minX - enlargeInsets.left,
            y: bounds.minY - enlargeInsets.top,
            width: bounds.width + enlargeInsets.left + enlargeInsets.right,
            height: bounds.height + enlargeInsets.top + enlargeInsets.bottom
        )
        return rect
    }
    
}
