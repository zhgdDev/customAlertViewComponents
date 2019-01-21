//
//  GDButton+Extension.swift
//  Mapping
//
//  Created by Dubai on 2019/1/20.
//  Copyright © 2019 hhcu. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, image: String, bgImage: String) {
       
        self.init()
        self.setBackgroundImage(UIImage(named: bgImage)?.withRenderingMode(.automatic), for: .normal)
        self.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        sizeToFit()
    }
    
}
