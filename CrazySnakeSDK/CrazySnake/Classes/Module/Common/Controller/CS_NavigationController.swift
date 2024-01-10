//
//  NavigationController.swift
//  constellation
//
//  Created by Lee on 2020/4/3.
//  Copyright © 2020 Constellation. All rights reserved.
//

import UIKit

open class NavigationController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.'
        self.isNavigationBarHidden = true;
        self.interactivePopGestureRecognizer?.delegate = self;
        self.delegate = self;
    }
    
    open override var childForStatusBarStyle: UIViewController? {

      return topViewController

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}


extension NavigationController: UIGestureRecognizerDelegate,UINavigationControllerDelegate{
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        
        if navigationController.viewControllers.count == 1 {
            
            self.interactivePopGestureRecognizer?.isEnabled = false
        }else{
//            if viewController.isKind(of: CS_BaseController.self){
//                let vc:CS_BaseController = viewController as! CS_BaseController
//                self.interactivePopGestureRecognizer?.isEnabled = vc.slideBackEnabled
//            }else{
//                self.interactivePopGestureRecognizer?.isEnabled = true
//            }
        }
        
    }
    
    
}
