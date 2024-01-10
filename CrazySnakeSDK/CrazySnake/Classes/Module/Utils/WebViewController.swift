//
//  WebViewController.swift
//  voice
//
//  Created by mac on 2023/4/4.
//
//  封装wkwebview，对js进行交互使用

import UIKit
import WebKit
import SnapKit

class WebViewController: CS_BaseEmptyController {
    var url: String = ""

    var wkWebView : WKWebView!

    
    
    public func loadUrl() {
        
        let url = URL(string: self.url)
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 15)
        wkWebView.load(request)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        createWkWebView()
        
        self.wkWebView.configuration.userContentController.add(self, name: "extractSignature")
        self.wkWebView.configuration.userContentController.add(self, name: "closeFunc")
        self.wkWebView.configuration.userContentController.add(self, name: "jumpFunc")

        self.view.addGestureRecognizer(UIPanGestureRecognizer())
        self.view.addGestureRecognizer(UITapGestureRecognizer())
        

        
    }
    
    deinit {
        debugPrint("WebViewController deinit 🍻")
    }
    
    public func sendMsgToWebView(_ msg : String) {
        
        let jsStr = """
        receiveNews('\(msg)')
        """
        self.wkWebView.evaluateJavaScript(jsStr) { (result, error) in
//            print("result = \(result)")
            print("error = \(error.debugDescription)")
            
        }
    }
    
    var viewDidDisappearHandle : (() -> ())?
    
    /// 从父视图移除
    var viewWillRemoveFromSuperview : (() -> ())?
    
    override func viewWillAppear(_ animated : Bool) {
        debugPrint("viewWillAppear")
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidDisappear(_ animated : Bool){
        debugPrint("viewDidDisappear")
        super.viewDidDisappear(animated)
        self.wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "extractSignature")
        self.wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "closeFunc")
        self.wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "jumpFunc")


        
        self.viewDidDisappearHandle?()

    }

    // 是否透明
    var isOpaque: Bool = true

    func createWkWebView() {
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .all
        
        

        let webView = WKWebView(frame: .zero , configuration: config)
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
        webView.customUserAgent = """
        Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16D5039a Safari/605.1 iLunascape/4310
        """
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

extension WebViewController : WKScriptMessageHandler {
    
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
        } else if message.name == "extractSignature" {
//            guard let address = accountInfo?.wallet_address else { return }
//            let (nonce, sign) = Utils.signInfo(privateKey: message.body as! String)
            if let content = message.body as? String {
                if let nonce = Utils.sign(privateKey: CS_AccountManager.shared.accountInfo?.private_key, content: message.body as! String) {
                    callJavaScriptMethod(nonce)
                }
            }
//            debugPrint(nonce,sign)
            
        }
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
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
