//
//  DisplayLabel.swift
//  ZapposCalculator
//
//  Created by Gaurav Nijhara on 2/12/16.
//  Copyright © 2016 Gaurav Nijhara. All rights reserved.
//

import UIKit

class DisplayLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func drawTextInRect(rect: CGRect) {
        let insets:UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 8);
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect,insets))
    }

}
