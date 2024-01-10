//
//  Utils.swift
//  Platform
//
//  Created by Lee on 25/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit
//import WalletCore

class Utils: NSObject {
    
    static func pathOfPag(_ name: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: "pag")
        return path ?? ""
    }
    
    // accountName form mnemonic words:
    // 1.mnemonic words md5
    // 2.prefix(8) the md5 string
    open class func walletAccountName(_ mnemonic: String) -> String {
        let account = mnemonic.ls_md5
        let name = account.prefix(8)
        return String(name)
    }
    
    @objc public static func isMnemonic(_ mnemonic: String?) -> Bool {
        guard let mnemonic = mnemonic else { return false }
        return Mnemonic.isValid(mnemonic: mnemonic)
    }

    
    static func isEthAddress(_ address: String?) -> Bool {
        guard let address = address else {
            return false
        }
        
        guard address.starts(with: "0x") else {
            return false
        }
        
        guard address.count == 42 else {
            return false
        }
        
        return true
    }
    
    static func isSolanaAddress(_ address: String?) -> Bool {
        guard let address = address else {
            return false
        }
        
        guard address.count == 44 else {
            return false
        }
        
        return true
    }

    static func digitalTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // allow backspace
        if string.count == 0 && range.length > 0 {
            return true
        }
        // do not allow . at the beggining
        if range.location == 0 && string.hasPrefix(".") {
            return false
        }
        
        if let currentText = textField.text {
            //alreay has a decimal point
            if currentText.contains(".") && string.contains(".") {
                return false
            }
            
            // do not allow 00 at the beggining
            if currentText == "0" && string.hasPrefix("0") {
                return false
            }
            
            let list = currentText.components(separatedBy: ".")
            if list.count > 1 {
                let decimalStr = list[1]
                if decimalStr.count + string.count > 8 {
                    return false
                }
            }
        }
        
        let lowerPattern = "0123456789."
        let predicate = NSPredicate(format: "SELF MATCHES %@", lowerPattern)
        if predicate.evaluate(with: string) {
            return false
        }
        
        return true
    }
    
    /// 10 --> 16
    static func decimalToHex(_ decimal: Int, hasProfix: Bool = false) -> String {
        if hasProfix {
            return String(format: "0x%0X", decimal)
        } else {
            return String(format: "%0X", decimal)
        }
    }
    
    static func formatAmount(_ string: String?, digits: Int = 6) -> String {
        guard let string = string else {
            return "0.00"
        }
        
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = digits
        guard let result = nf.string(from: NSNumber(value: Float(string) ?? 0)) else {
            return "0.00"
        }
        return result
    }
    
    static func getCellularSignalStrength() -> Int? {
        if #available(iOS 13.0, *) {
            if let statusBarManager = UIApplication.shared.keyWindow?.windowScene?.statusBarManager,
                let localStatusBar = statusBarManager.value(forKey: "createLocalStatusBar") as? NSObject,
                let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
                let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                let celluarEntry = currentData.value(forKey: "cellularEntry") as? NSObject,
                let signalStrength = celluarEntry.value(forKey: "displayValue") as? Int {
                return signalStrength
            } else {
                return nil
            }
        }
        if #available(iOS 12.0, *) {
            let application = UIApplication.shared
            if  let statusBar = application.value(forKey: "statusBar") as? UIView,
                let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                let celluarEntry = currentData.value(forKey: "cellularEntry") as? NSObject,
                let signalStrength = celluarEntry.value(forKey: "displayValue") as? Int {
                return signalStrength
            } else {
                return nil
            }
        } else {
            var signalStrength = -1
            let application = UIApplication.shared
            let statusBarView = application.value(forKey: "statusBar") as? UIView
            let foregroundView = statusBarView?.value(forKey: "foregroundView") as? UIView
            if let foregroundViewSubviews = foregroundView?.subviews {
                for subview in foregroundViewSubviews {
                    if subview.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
                        signalStrength = subview.value(forKey: "_signalStrengthBars") as? Int ?? -1
                        break
                    }
                }
            }
            if signalStrength != -1 {
                return signalStrength
            } else {
                return nil
            }
        }
    }
    
    static func getWifiSignalStrength() -> Int? {
        if #available(iOS 13.0, *) {
            if let statusBarManager = UIApplication.shared.keyWindow?.windowScene?.statusBarManager,
                let localStatusBar = statusBarManager.value(forKey: "createLocalStatusBar") as? NSObject,
                let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
                let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                let wifiEntry = currentData.value(forKey: "wifiEntry") as? NSObject,
                let wiftStrength = wifiEntry.value(forKey: "displayValue") as? Int {
                return wiftStrength
            } else {
                return nil
            }

        }
        
        if #available(iOS 12.0, *) {
            let application = UIApplication.shared
            if  let statusBar = application.value(forKey: "statusBar") as? UIView,
                let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                let wifiEntry = currentData.value(forKey: "wifiEntry") as? NSObject,
                let wiftStrength = wifiEntry.value(forKey: "displayValue") as? Int {
                return wiftStrength
            } else {
                return nil
            }
        } else {
            var wifiStrengthBar = -1
            let application = UIApplication.shared
            let statusBarView = application.value(forKey: "statusBar") as? UIView
            let foregroundView = statusBarView?.value(forKey: "foregroundView") as? UIView
            if let foregroundViewSubviews = foregroundView?.subviews{
                for subview in foregroundViewSubviews {
                    if subview.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                        wifiStrengthBar = subview.value(forKey: "_wifiStrengthBars") as? Int ?? -1
                        break
                    }
                }
            }
            if wifiStrengthBar != -1 {
                return wifiStrengthBar
            } else {
                return nil
            }
        }
    }
}
