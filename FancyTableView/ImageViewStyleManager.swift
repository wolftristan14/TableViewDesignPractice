//
//  ImageViewStyleManager.swift
//  FancyTableView
//
//  Created by Tristan Wolf on 2018-06-17.
//  Copyright © 2018 Tristan Wolf. All rights reserved.
//

import Foundation
import UIKit

class ImageViewStyleManager: UIImageView {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 8
    }
    
}
