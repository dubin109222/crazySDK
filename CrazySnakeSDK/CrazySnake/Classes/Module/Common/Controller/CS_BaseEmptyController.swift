//
//  CS_BaseEmptyController.swift
//  Platform
//
//  Created by Lee on 16/11/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class CS_BaseEmptyController: CS_BaseController {
    
    enum ControllerEmptyStyle: Int {
        case none = 0
        case loading = 1
        case empty = 2
        case error = 3
    }
    
    var tag: Int = 0
    var filterStr: String? = nil
    
    var emptyStyle: ControllerEmptyStyle = .loading
    var emptyImageName = "icon_empty_nft@2x"
    var errorImageName = "icon_request_error"
    var titleColor = UIColor.ls_dark_3()
    var emptyTitle = "crazy_str_empty".ls_localized
    var errorTitle = "crazy_str_tip_error".ls_localized
    var descriptionColor = UIColor.ls_dark()
    var emptyDescription = "".ls_localized
    var errorDescription = "".ls_localized
    /// <0 move up； >0 move down
    var verticalOffsetForEmpty = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func emptyViewDidTapErrorView() {
        
    }
    
}

extension CS_BaseEmptyController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        switch emptyStyle {
        case .loading:
            return UIImage.ls_bundle( "icon_loading")
        case .empty:
            return UIImage.ls_bundle( emptyImageName)
        case .error:
            return UIImage.ls_bundle( errorImageName)
        default:
            return nil
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString? {
        if emptyTitle.count > 0 {
            var title = emptyTitle
            switch emptyStyle {
            case .empty:
                title = emptyTitle
            case .error:
                title = errorTitle
            default:
                return nil
            }
            let attri = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font: UIFont.ls_JostRomanFont(19),NSAttributedString.Key.foregroundColor: titleColor])
            return attri
        } else {
            var title = emptyDescription
            switch emptyStyle {
            case .empty:
                title = emptyDescription
            case .error:
                title = errorDescription
            default:
                return nil
            }
            let attri = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font: UIFont.ls_JostRomanFont(12),NSAttributedString.Key.foregroundColor: descriptionColor])
            return attri
        }
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if emptyTitle.count == 0 {
            return NSAttributedString.init()
        }
        var title = emptyDescription
        switch emptyStyle {
        case .empty:
            title = emptyDescription
        case .error:
            title = errorDescription
        default:
            return nil
        }
        let attri = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font: UIFont.ls_JostRomanFont(12),NSAttributedString.Key.foregroundColor: descriptionColor])
        return attri
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return verticalOffsetForEmpty
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return emptyStyle == .loading
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation? {
        if emptyStyle == .loading {
            let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            animation.duration = 1.0
            animation.repeatCount = MAXFLOAT
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            return animation
        } else {
            return nil
        }
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTap(_ scrollView: UIScrollView!) {
        if emptyStyle == .error {
            emptyViewDidTapErrorView()
        }
    }
}

