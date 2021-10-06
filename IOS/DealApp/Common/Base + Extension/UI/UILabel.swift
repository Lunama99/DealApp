//
//  UILabel.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

@IBDesignable class BaseLabel: UILabel {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
    
    @IBInspectable var style: Int = 0 {
        didSet {
            switch style {
            case 0: // Heading
                font = R.font.poppinsSemiBold(size: 24)
                textColor = UIColor.init(hexString: "#374957")
            case 1: // Textfield
                font = R.font.poppinsSemiBold(size: 14)
                textColor = UIColor.init(hexString: "#374957")
            case 2: // Check box
                font = R.font.poppinsRegular(size: 14)
                textColor = UIColor.init(hexString: "#374957")
            case 3: // title home
                font = R.font.poppinsMedium(size: 14)
                textColor = UIColor.init(hexString: "#374957")
            default: break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

