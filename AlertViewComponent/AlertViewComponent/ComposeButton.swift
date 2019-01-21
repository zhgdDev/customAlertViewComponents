//
//  ComposeButton.swift
//  SwiftAlertVIewComponent
//
//  Created by Dubai on 2019/1/21.
//  Copyright © 2019 hhcu. All rights reserved.
//

import UIKit

class ComposeButton: UIControl {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var clsName:String?
    
    class func composeTypeButton(image: String, title: String) ->  ComposeButton{
        let nib = UINib(nibName: "ComposeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeButton
        
        btn.imageView.image = UIImage(named: image)
        btn.titleLabel.text = title
        return btn
    }
    
    
}
