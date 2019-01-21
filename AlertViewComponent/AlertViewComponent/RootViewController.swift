//
//  RootViewController.swift
//  Mapping
//
//  Created by Dubai on 2019/1/20.
//  Copyright © 2019 hhcu. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController
{
    private lazy var composeButton:UIButton = UIButton(title: "", image: "btn_addIcon", bgImage: "btn_bgImage")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setupChildControllers()
        setupComposeButton()
    }
    
    @objc private func composeAction()  {
        print("composeAction")
        
//        let vc = AlertViewController()
//        let nc = UINavigationController(rootViewController: vc)
//        //vc.modalTransitionStyle = .flipHorizontal
//        present(nc, animated: true, completion: nil)
        
        let v = GDComposeView.composeTypeView()
        
        v.show { [weak v](name) in
            
            guard let clsName = name,
                let cls = NSClassFromString(Bundle.main.nameSpace + "." + (clsName ?? "")) as? UIViewController.Type else {
                    return
            }
            
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true) {
                v?.removeFromSuperview()
            }
            
        }
        
//        v.show { (clsName) in
//            print("x展示控制器")
//            guard let name = clsName else {
//
//                let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName!) as? UIViewController.Type
//                print(cls)
//
//            //    let vc = cls.type(of: init)()
//
//            }
//
//        }
        
    }
}

extension RootViewController
{
    private func setupComposeButton()
    {
        composeButton.backgroundColor = UIColor.blue

        let count = CGFloat(viewControllers!.count)
        let w = (tabBar.bounds.width) / count - 1
        composeButton.frame = tabBar.bounds.insetBy(dx:w * 1, dy: 0)
        tabBar.addSubview(composeButton)

        composeButton.addTarget(self, action: #selector(composeAction), for: .touchUpInside)
    }
    
    //设置u所有子控制器
   private func setupChildControllers()
    {
        let array = [["clsName":"HomeViewController","title":"首页"],
                     ["clsName":"DemoViewController","title":"发现"],
                     ["clsName":"HomeViewController","title":"我的"]] as [Any]
        
        var arrayVC = [UIViewController]()
        
        for d in array {
            arrayVC.append(controller(dict: d as! [String : String]))
        }
        
        viewControllers = arrayVC
    }
    
    //映射返回UIViewController
    private func controller(dict:[String:String]) -> UIViewController
    {
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            //创建子控制器
            //将clsName转换成UIViewController class
            //swift有命名空间 默认是整个项目
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type
            else {
            
                return UIViewController()
        }
        
        
       let vc = cls.init()
        vc.title = title
        
        //设置tabBar的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.orange], for: .highlighted)
        
        //系统默认12
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], for: UIControl.State(rawValue: 0))
        
        //压栈
        let nav = UINavigationController(rootViewController:vc)
       
        return nav
    }
}

