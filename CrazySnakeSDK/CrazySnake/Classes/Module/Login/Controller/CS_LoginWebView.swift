//
//  CS_LoginWebView.swift
//  CrazySnake
//
//  Created by BigB on 2023/12/12.
//

import UIKit
import WebKit
import SnapKit

class RSProcessPool{
    static let  shared = WKProcessPool()
}
class CS_LoginWebView: CS_BaseEmptyController {
    var url: String = ""
    var wkWebView : WKWebView!

    
    
    public func loadUrl() {
        
        let url = URL(string: self.url)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("ios", forHTTPHeaderField: "x-os")
        wkWebView.load(request)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        createWkWebView()
        
        self.wkWebView.configuration.userContentController.add(self, name: "tokenHandler")

        self.view.addGestureRecognizer(UIPanGestureRecognizer())
        self.view.addGestureRecognizer(UITapGestureRecognizer())
    }
    
    deinit {
        debugPrint("CS_LoginWebView deinit 🍻")
    }
    
    var viewDidDisappearHandle : (() -> ())?
    
    /// 从父视图移除
    var viewWillRemoveFromSuperview : (() -> ())?
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated : Bool){
        debugPrint("viewDidDisappear")
        super.viewDidDisappear(animated)
        self.wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "tokenHandler")
        
        self.viewDidDisappearHandle?()

    }

    // 是否透明
    var isOpaque: Bool = true

    func createWkWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .all
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        config.userContentController = WKUserContentController()
//        config.userContentController.add(context.coordinator , name: "tokenHandler")
        config.processPool = RSProcessPool.shared
        config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")


        let webView = WKWebView(frame: .zero , configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true

        self.wkWebView = webView
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }

        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.bounces = false
        webView.scrollView.backgroundColor = .clear
        webView.uiDelegate = self
        webView.navigationDelegate = self
  
        webView.customUserAgent = "ios"
//        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16D5039a Safari/605.1 iLunascape/4310"
        webView.configuration.suppressesIncrementalRendering = true


        self.view.addSubview(webView)

//        if isOpaque {
//            wkWebView.isOpaque = true
//        } else {
        webView.isOpaque = false
        webView.backgroundColor = .clear
//        }

        webView.snp.makeConstraints { (make) in
            
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarHeight)
        }

    }
}

extension CS_LoginWebView : WKScriptMessageHandler {
    
    // Button click event
    private func callJavaScriptMethod(_ nonce : String) {
        let javascriptFunction = "getSign('\(nonce)');"

        wkWebView.evaluateJavaScript(javascriptFunction) { (result, error) in
            if let error = error {
                print("Error executing JavaScript: \(error)")
            }
        }
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.name = \(message.name)")
        print("message.body = \(message.body)")
        
        if message.name == "closeFunc" {
            self.viewWillRemoveFromSuperview?()
        } else if message.name == "tokenHandler" {
            let dic = message.body as? [String: String]
            let base64Str = dic!["data"]
            let data = Data(base64Encoded: base64Str!)
            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            struct LoginModel: Codable {
                var id: Int
                var name: String
                var wallet_address: String
                var avatar: String
                var device_id: String
                var os: String
                var ip: String
                var parent_id: Int
                var gas_coin_left: String
                var gas_coin_used: String
                var nft_staking_total_reward: String
                var nft_staking_claimable_reward: String
                var nft_staking_slots_count: Int
                var ticket_amount: String
                var cash_amount: String
                var avatar_image: String
                var private_key: String
                var mnemonic: String
                var thrid_platform: String
            }
            if let model = try? JSONDecoder().decode(LoginModel.self, from: data!) {
                
                let list = AccountModel.findAccountList()
                if let _ = list.first(where: {$0.private_key == model.private_key}) {
                    LSHUD.showError("Wallet is already exsit".ls_localized)
                    self.pop(true)
                    return
                }
                
                let account = AccountModel()
                account.private_key = model.private_key
                account.wallet_address = model.wallet_address
                account.backupStatus = "1"
                account.id = "\(model.id)"
                account.save()
                CSSDKManager.shared.walletLoginType = 2
                CS_AccountManager.shared.accountInfo = account
                
                UserDefaults.standard.setValue(account.id, forKey: CacheKey.lastSelectedAccountId)
                NotificationCenter.default.post(name: NotificationName.importMenmonicWalletSuccess, object: nil)

            }
        }
    }
}

extension CS_LoginWebView: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载")

    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("开始获取到网页内容")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
    }
}
