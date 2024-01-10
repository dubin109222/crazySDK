//
//  CS_BaseController.swift
//  constellation
//
//  Created by Lee on 2020/4/3.
//  Copyright © 2020 Constellation. All rights reserved.
//
/*
 */

import UIKit

open class CS_BaseController: UIViewController {

    var showNavifationBar = true
    var slideBackEnabled = true
    var isPresentVC = false
    
    var titleImage: UIImage? {
        didSet {
            self.navigationView.titleImageView.image = titleImage
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ls_setupView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubviewToFront(navigationView)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        hidesBottomBarWhenPushed = true
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func back(){
        pop()
    }

    func pushTo(_ vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVC(_ vc: UIViewController){
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentVC(_ vc: UIViewController,style:UIModalPresentationStyle){
        vc.modalPresentationStyle = style
        self.present(vc, animated: true, completion: nil)
    }
    
    func pop(_ animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    func popTo(_ vcClass: AnyClass, animated: Bool = true){        
        guard let viewControllers = navigationController?.viewControllers else {
            pop()
            return
        }
        for vc in viewControllers {
            if vc.isKind(of: vcClass) {
                navigationController?.popToViewController(vc, animated: animated)
                return
            }
        }
        pop()
    }
    
    deinit {
//        noticeCenter.removeObserver(self)
        LSLog("deinit \(self)")
    }
    
    lazy var navigationView: CS_NavigationView = {
        let view = CS_NavigationView(frame: CGRect(x: 0, y: 0, width: CS_kScreenW, height: 44))
        view.leftButton.addTarget(self, action: #selector(leftReturnAction), for: .touchUpInside)
//        view.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        view.isHidden = !showNavifationBar
        view.changeStyle(.normal)
        return view
    }()
    
    lazy var topBackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.navigationView.bottom-2, width: CS_kScreenW, height: 34+2))
        view.backgroundColor = UIColor.ls_dark_3()
        view.isHidden = true
        return view
    }()
    
    lazy var bottomBarView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: CS_kScreenH-34, width: CS_kScreenW, height: 34))
        view.backgroundColor = UIColor.ls_dark_3()
        view.isHidden = true
        return view
    }()
    
    lazy var backView: UIImageView = {
        let view = UIImageView(frame: self.view.bounds)
//        view.image = UIImage.ls_bundle( "bg_image")
        view.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .ls_color("#222222")
        return view
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        button.isHidden = true
        button.setImage(UIImage.ls_bundle( "icon_nav_tips@2x"), for: .normal)
        return button
    }()
    
    lazy var navAmountView: CS_AmountView = {
        let view = CS_AmountView()
        view.isHidden = true
        return view
    }()
    
    lazy var navAmountView1: CS_AmountView = {
        let view = CS_AmountView()
        view.isHidden = true
        return view
    }()
    
    lazy var navAmountView2: CS_AmountView = {
        let view = CS_AmountView()
        view.isHidden = true
        return view
    }()
}

extension CS_BaseController{

    @objc func leftReturnAction(){
        if isPresentVC {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if navigationView.style == .present{
            dismiss(animated: true, completion: nil)
        }else {
            pop()
        }
    }
//
//    @objc func rightAction(){
//
//    }
    
    @objc func clickRightButton() {
    }
}

fileprivate extension CS_BaseController{
    

    func navBarShadowImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: CS_kScreenW, height: 0.5), false, 0)
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: CS_kScreenW, height: 0.5))
        UIColor.clear.setFill()
        path.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        return img
    }
    
}

//MARK: UI
extension CS_BaseController {
    
    private func ls_setupView() {
        
        view.addSubview(backView)
        view.addSubview(topBackView)
        view.addSubview(bottomBarView)
        view.addSubview(navigationView)
        view.backgroundColor = UIColor.ls_white()
        
        navigationView.addSubview(navAmountView)
        navigationView.addSubview(navAmountView1)
        navigationView.addSubview(navAmountView2)
        
        navAmountView.snp.makeConstraints { make in
            make.right.equalTo(-62)
            make.centerY.equalTo(navigationView)
            make.width.equalTo(150)
            make.height.equalTo(34)
        }
        
        navAmountView1.snp.makeConstraints { make in
            make.width.height.centerY.equalTo(navAmountView)
            make.right.equalTo(navAmountView.snp.left).offset(-35)
        }
        
        navAmountView2.snp.makeConstraints { make in
            make.width.height.centerY.equalTo(navAmountView)
            make.right.equalTo(navAmountView1.snp.left).offset(-35)
        }
        
        navigationView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalTo(navigationView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
}
