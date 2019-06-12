//
//  UITextFieldExt.swift
//  DemoArKit
//
//  Created by Chính Phạm on 6/12/19.
//  Copyright © 2019 Chinh Pham N. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat){
        let newFrame = CGRect(origin: .zero, size: CGSize(width: amount, height: frame.height))
        let paddingView = UIView(frame: newFrame)
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount: CGFloat) {
        let newFrame = CGRect(origin: .zero, size: CGSize(width: amount, height: frame.height))
        let paddingView = UIView(frame: newFrame)
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
