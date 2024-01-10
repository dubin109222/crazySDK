//
//  CS_WalletBaseController.swift
//  CrazySnake
//
//  Created by Lee on 10/07/2023.
//

import UIKit

class CS_WalletBaseController: UIViewController {
    
    var showNavifationBar = true
    var slideBackEnabled = true
    var isPresentVC = false
    
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
        view.backView.image = nil
        view.backView.backgroundColor = .ls_color("#1E1E20")
        return view
    }()
    
    lazy var backView: UIImageView = {
        let view = UIImageView(frame: self.view.bounds)
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .ls_color("#171718")
        return view
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
}

extension CS_WalletBaseController{

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
    @objc func clickRightButton() {
    }
}

fileprivate extension CS_WalletBaseController{
    
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
extension CS_WalletBaseController {
    
    private func ls_setupView() {
        
        view.addSubview(backView)
        view.addSubview(navigationView)
        view.backgroundColor = UIColor.ls_white()
        
        navigationView.addSubview(rightButton)
        
        navigationView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.bottom.equalTo(navigationView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
}

