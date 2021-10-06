//
//  UITextField.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import UIKit

class BaseTextField: UITextField {
    
    // Const
    let attributes = [
        NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#BAC7D2"),
        NSAttributedString.Key.font : R.font.poppinsRegular(size: 14)
    ]

    // Variable
    var padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    var didChangeValue: ((String)->Void)?
    var didEndEditing: ((String)->Void)?
    
    // Design UI
    @IBInspectable var style: Int = 0 {
        didSet {
            switch style {
            case 0:
                padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            case 1:
                padding = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            default: break
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        didChangeValue?(textField.text ?? "")
    }
    
    @objc func textFieldEndEditing(_ textField: UITextField) {
        didEndEditing?(textField.text ?? "")
    }
    
    func setupView() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(textFieldEndEditing), for: .editingChanged)
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: attributes as [NSAttributedString.Key : Any])
        font = R.font.poppinsRegular(size: 14)
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
}
