//  PaddedLabel.swift
//  Musiary
//  Created by 박다현

import UIKit

class PaddedLabel: UILabel {
    let padding = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + padding.left + padding.right,
                      height: originalSize.height + padding.top + padding.bottom)
    }
}
