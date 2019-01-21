//
//  GDNavigationBar.swift
//  Mapping
//
//  Created by Dubai on 2019/1/20.
//  Copyright © 2019 hhcu. All rights reserved.
//

import UIKit

class GDNavigationBar: UINavigationBar
{
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRect())
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        for na in self.subviews {
            let name = NSStringFromClass(type(of: na))
            // let subString = (name as NSString).containsString("Swift")
            print("hello DUBUG \(name)")
            if name.contains("Background") {
                var fr = na.frame
                fr.size.height = 64
                na.frame = fr
            } else if name.contains("ContentView") {
                var fr = na.frame
                fr.origin.y = 20
                na.frame = fr;
            }
        }
    }


}
