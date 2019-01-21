//
//  GDComposeView.swift
//  SwiftAlertVIewComponent
//
//  Created by Dubai on 2019/1/21.
//  Copyright © 2019 hhcu. All rights reserved.
//

import UIKit
import pop

class GDComposeView: UIView {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeBtnCenterCons: NSLayoutConstraint!
    
    @IBOutlet weak var returnBtn: UIButton!


    @IBOutlet weak var returnBtnCenterCons: NSLayoutConstraint!
    
    private let buttonInfo = [["imageName":"shareN_weibo","title":"微博", "clsName":"DemoViewController"],
                              ["imageName":"shareN_wechat","title":"微信", "clsName":"DemoViewController"],
                              ["imageName":"shareN_qq","title":"QQ", "clsName":"DemoViewController"],
                              ["imageName":"shareN_penyouquan","title":"朋友圈", "clsName":"DemoViewController"],
                              ["imageName":"shareN_qzone","title":"QQ空间", "clsName":"DemoViewController"],
                              ["imageName":"share_copy","title":"更多","actionName":"clickMore"],
                              ["imageName":"sharemore_video","title":"视频", "clsName":"DemoViewController"],
                              ["imageName":"sharemore_folder","title":"文件", "clsName":"DemoViewController"],
                              ["imageName":"sharemore_evalue","title":"花花", "clsName":"DemoViewController"],
                              ["imageName":"sharemore_ album","title":"照片", "clsName":"DemoViewController"]
                              ]
    
    
    private var completionBlock: ((_ clsName: String?) ->())?
    
    class func composeTypeView() -> GDComposeView
    {
        let nib = UINib.init(nibName: "GDComposeView", bundle: nil)
        let v = nib.instantiate(withOwner: nib, options: nil)[0] as! GDComposeView
        v.frame = UIScreen.main.bounds
        v.setupUI()
    

        return v
    }
    
    @objc private func clickMe(sender: ComposeButton) {
        print("--点我了---")
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //便利当前视图,选中的按钮放大,未选中的按钮缩小
        for (i, btn) in v.subviews.enumerated() {
            //放大缩放
            let scaleAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (sender == btn) ? 2 : 0.3
            let value = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.toValue = value
            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            //渐变
            let alphaAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.3
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            
            //监听最后动画完成
            if i==0 {
                alphaAnim.completionBlock = { _,_ in
                    //回调展现ViewController
                    self.completionBlock?(sender.clsName)
                }
            }
            
        }
        
//        let cls = NSClassFromString(Bundle.main.nameSpace + "." + (sender.clsName  ?? "")) as? UIViewController.Type
//        UINavigationController.pushViewController(<#T##UINavigationController#>)
        
    }
    
    //返回上一页
    @IBAction func returnBack(_ sender: Any)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        closeBtnCenterCons.constant = 0
        returnBtnCenterCons.constant = 0
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()

        }) { _ in
           weakSelf?.returnBtn.isHidden = true
        }
    }
    
    @objc func clickMore()
    {
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        returnBtn.isHidden = false
        closeBtnCenterCons.constant = 100
        returnBtnCenterCons.constant -= 100
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        hideButtons()
    }
    
    func show(completion: @escaping (_ clsName: String?) ->()) {
        
        //记录闭包
        completionBlock = completion
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else
        {
            return
        }
        
        vc.view.addSubview(self)
        
        //开始动画
        showCurrentView()
    }
    
//    override func awakeFromNib()
//    {
//        setupUI()
//    }
    
}

//MARK:--动画扩展
private extension GDComposeView
{
    //MARK:--隐藏按钮
    private func hideButtons()
    {
        //根据a当前contentoffseta判断当前视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //便利v中所有按钮子视图
        for (i,btn) in v.subviews.enumerated().reversed() {
            let anmi:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anmi.fromValue = btn.center.y
            anmi.toValue = btn.center.y + 350
            
            //设置时间
            anmi.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025

            btn.layer.pop_add(anmi, forKey: nil)
            
            //隐藏当前视图  不用removeFromSuperview()
            //监听最后一个按钮

            if i == 0 {
                anmi.completionBlock = {(_,_)  in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    private func hideCurrentView() {
        let anmi:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anmi.fromValue = 1
        anmi.toValue = 0
        anmi.duration = 0.25
        pop_add(anmi, forKey: nil)
        anmi.completionBlock = { _,_ in
            self.removeFromSuperview()
            
        }
    }
    
    private func showCurrentView()
    {
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        //添加到视图
        pop_add(anim, forKey: nil)
        showButtons()
    }
    
    //弹力显示button
    private func showButtons()
    {
        let v = scrollView.subviews[0]
        
        //便利v中所有的按钮
        for (i,btn) in v.subviews.enumerated() {
            let anmi = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anmi?.fromValue = btn.center.y + 350
            anmi?.toValue = btn.center.y
            //弹力系数
            anmi?.springBounciness = 8
            //弹力速度
            anmi?.springSpeed = 8
            anmi?.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            btn.pop_add(anmi, forKey: nil)
        }
        
    }
    
}

private extension GDComposeView
{
    func setupUI()
    {
//        let btn = ComposeButton.composeTypeButton(image: "share_copy-1", title: "微博")
//        btn.frame = CGRect(x: 40, y: 150, width: 100, height: 100)
//        btn.addTarget(self, action: #selector(clickMe), for: .touchUpInside)
//        addSubview(btn)
        
        //强行更新j布局
        layoutIfNeeded()

        let rect = scrollView.bounds
        let width = scrollView.bounds.width
        
        for i in 0..<2
        {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            addBtn(v: v, index: i * 6)
            scrollView.addSubview(v)

        }
        
//        let v = UIView(frame: rect)
//        addBtn(v: v, index: 6)
//        scrollView.addSubview(v)
//        scrollView.backgroundColor = UIColor.green
        
        //设置scrollView
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
    }
    
    func addBtn(v: UIView, index: Int)
    {
        let count = 6
        for i in index..<(index + count)
        {
            if i >= buttonInfo.count
            {
                break
            }
            
            let dict = buttonInfo[i]
            
           guard let imageName = dict["imageName"],
                 let title = dict["title"] else
           {
                continue
            }


            let btn = ComposeButton.composeTypeButton(image: imageName, title: title)
            v.addSubview(btn)
            //NSSelectorFromString(<#T##aSelectorName: String##String#>)
            if let actionName = dict["actionName"]
            {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            else
            {
                btn.addTarget(self, action: #selector(clickMe), for: .touchUpInside)
            }
            
            btn.clsName = dict["clsName"]
        }
        
        let btnSize = CGSize(width: 100, height: 100)
        
        //间距
        let margrn = (v.bounds.width - 3 * btnSize.width) / 4
        
        //便利子视图布局
        for (i,btn) in v.subviews.enumerated()
        {
            let y:CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margrn + CGFloat(col)*btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
}





















