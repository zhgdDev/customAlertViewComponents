//
//  DemoViewController.swift
//  Mapping
//
//  Created by Dubai on 2019/1/20.
//  Copyright © 2019 hhcu. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blue
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "back", style: .plain, target: self, action: #selector(back))
        
    }
    
    @objc func back()
    {
        self.dismiss(animated: true, completion: nil)
    }
        
}

