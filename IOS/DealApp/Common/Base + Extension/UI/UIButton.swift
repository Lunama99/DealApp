//
//  UIButton.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

@IBDesignable class BaseButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var style: Int = 0 {
        didSet {
            switch style {
            case 0: // Check box-view
                layer.borderWidth = 1
                layer.borderColor = UIColor.init(hexString: "#D0CCCC").cgColor
            case 1: // Check box-text
                titleLabel?.font = R.font.poppinsRegular(size: 14)
                setTitleColor(UIColor.init(hexString: "#374957"), for: .normal)
            case 2: // Default
                setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
                applyGradient(colors: [UIColor.init(hexString: "#00AAF2 -0.17%").cgColor, UIColor.init(hexString: "#64DCFC 99.81").cgColor])
            case 3: // Social-login
                layer.borderWidth = 1
                titleLabel?.font = R.font.poppinsRegular(size: 14)
                setTitleColor(UIColor.init(hexString: "#374957"), for: .normal)
                layer.borderColor = UIColor.init(hexString: "#D0CCCC").cgColor
            case 4: // Back button black
                frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                setImage(R.image.ic_back(), for: .normal)
                sizeToFit()
//            case 5: // wallet title
//                setTitleColor(.black, for: .normal)
//                titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
//                sizeToFit()
//            case 6: // button icon
//                frame = CGRect(x: 0, y: 0, width: 20, height: 30)
//                titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
//            // Segment
//            case 7: // Selected
//                setTitleColor(.lightGray, for: .normal)
//                backgroundColor = .white
//                alpha = 0.5
//            case 8: // Unselected
//                setTitleColor(.white, for: .normal)
//                backgroundColor = .systemOrange
//                alpha = 1
//            // Navigation for tabbar
//            case 9: // Header title
//                isUserInteractionEnabled = false
//                titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
//            case 10: // Back button white
//                frame = CGRect(x: 0, y: 0, width: 20, height: 30)
//                let image = R.image.ic_back()?.withRenderingMode(.alwaysTemplate)
//                setImage(image, for: .normal)
//                tintColor = .white
//            case 11: // Select chain
//                titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
//                contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//                sizeToFit()
//            // Icon-eye-white
//            case 12:
//                let image = imageView?.image?.withRenderingMode(.alwaysTemplate)
//                setImage(image, for: .normal)
//                tintColor = .white
            default: break
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds

        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
    }
    
    func setwWarning(_ isShow: Bool) {
        if isShow {
            layer.borderWidth = 1
            layer.borderColor = UIColor.red.cgColor
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func setRadiusAndShadow() {
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }
    
    func setBorderButton(color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}

class BadgeButton: UIButton {

    private var badgeLabel = UILabel()
    var badgeImageView = UIImageView()
    
    var badge: Int = 0 {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }

    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }

    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }

    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addbadgetobutton(badge: 0)
        }
    }
    
    public var badgeImage: UIImage? {
        didSet {
            badgeImageView.image = badgeImage
        }
    }
    
    public var badgeImageFrame: CGRect? {
        didSet {
            badgeImageView.frame = badgeImageFrame ?? CGRect.zero
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addbadgetobutton(badge: 0)
    }

    func addbadgetobutton(badge: Int) {
        badgeLabel.text = "\(badge)"
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size

        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 5.0)

        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)

            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }

        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        badgeImageView.center = self.center
        badgeImageView.isUserInteractionEnabled = false
        
        addSubview(badgeImageView)
        addSubview(badgeLabel)
        
        badgeLabel.isHidden = badge < 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addbadgetobutton(badge: 0)
        fatalError("init(coder:) is not implemented")
    }
}
