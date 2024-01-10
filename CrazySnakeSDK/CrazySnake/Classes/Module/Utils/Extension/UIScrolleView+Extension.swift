//
//  UIScrolleView+Extension.swift
//  Platform
//
//  Created by Lee on 27/06/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    func ls_addHeader(_ beginRefresh: Bool, animation: Bool = false, refreshAction: CS_NoParasBlock?) {
        let mjRefreshHeader = MJRefreshNormalHeader { () in
            refreshAction?()
        }
        
        mjRefreshHeader?.setTitle("Pull down to refresh".ls_localized, for: .idle)
        mjRefreshHeader?.setTitle("Release to refresh".ls_localized, for: .pulling)
        mjRefreshHeader?.setTitle("Loading...".ls_localized, for: .refreshing)
        mjRefreshHeader?.stateLabel.font = UIFont.systemFont(ofSize: 14)
        mjRefreshHeader?.lastUpdatedTimeLabel.isHidden = true
        self.mj_header = mjRefreshHeader
        
        if beginRefresh {
            if animation {
                self.mj_header.beginRefreshing()
            } else {
                self.mj_header.executeRefreshingCallback()
            }
        }
    }
    
    func ls_addFooter(_ auto: Bool=true, loadMoreAction: CS_NoParasBlock?) {
        if auto {
            let mjRefreshFooter = MJRefreshAutoNormalFooter { () in
                loadMoreAction?()
            }
            mjRefreshFooter?.setTitle("Tap or pull up to load more".ls_localized, for: .idle)
            mjRefreshFooter?.setTitle("Loading".ls_localized, for: .refreshing)
            mjRefreshFooter?.setTitle("No more data".ls_localized, for: .noMoreData)
    //        mjRefreshFooter?.stateLabel.font = UIFont.systemFont(ofSize: 14)
            self.mj_footer = mjRefreshFooter
        } else {
            let mjRefreshFooter = MJRefreshBackNormalFooter { () in
                loadMoreAction?()
            }
            mjRefreshFooter?.setTitle("Tap or pull up to load more".ls_localized, for: .idle)
            mjRefreshFooter?.setTitle("Loading".ls_localized, for: .refreshing)
            mjRefreshFooter?.setTitle("No more data".ls_localized, for: .noMoreData)
    //        mjRefreshFooter?.stateLabel.font = UIFont.systemFont(ofSize: 14)
            self.mj_footer = mjRefreshFooter
        }
    }
    
    public func ls_refresh(_ withAnimation: Bool = false) {
        if mj_header != nil {
            if withAnimation {
                mj_header.beginRefreshing()
            } else {
                mj_header.executeRefreshingCallback()
            }
        }
    }
    
    func ls_compeletLoading(_ isRefresh: Bool, hasMore: Bool = true) {
        if isRefresh {
            if mj_header != nil {
                mj_header.endRefreshing()
            }
            if mj_footer != nil {
                mj_footer.state = .idle
            }
        } else {
            if mj_header != nil {
                mj_header.endRefreshing()
            }
            if mj_footer != nil {
                mj_footer.endRefreshing()
            }
        }
        
        if hasMore == false && mj_footer != nil {
            mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
