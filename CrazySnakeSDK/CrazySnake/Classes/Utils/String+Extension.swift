//
//  String+Extension.swift
//  ActiveProject
//
//  Created by Lee on 2018/8/10.
//  Copyright © 2018年 7moor. All rights reserved.
//

import UIKit
import CommonCrypto
import Foundation
import CryptoKit

// 实现heightWithConstrainedWidth方法
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return boundingBox.height
    }
}


extension String {
   static func formatSecondsToHHMMSS(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60

        let formattedString = String(format: "%02dH:%02dM:%02dS", hours, minutes, seconds)
        return formattedString
    }
    
    

    
    var ls_md5 : String{
        let strEncoding = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        guard let str = strEncoding else {
            assert(strEncoding != nil, "str in md5 appear to nil")
            return self
        }
        CC_MD5(str, strLen, result)

        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        free(result)
        return String(format: hash as String)
    }
    
    var ls_pwd_encode : String? {
        do {
            let data = Data(self.utf8)
            let hash = Insecure.MD5.hash(data: data)
            let bytes = [UInt8](hash)
            
            var sb = ""
            for byte in bytes {
                let c = byte & 0xff
                let result = String(format: "%02x", c)
                sb += result
            }
            
            let startIndex = sb.index(sb.startIndex, offsetBy: 8)
            let endIndex = sb.index(startIndex, offsetBy: 16)
            return String(sb[startIndex..<endIndex])
        } catch {
            print(error)
            return nil
        }
    }
    
    func ls_urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    
    func ls_height(_ font: UIFont, maxWith: CGFloat) -> CGFloat {
        let tempStr = self as NSString
        return tempStr.boundingRect(with: CGSize.init(width: maxWith, height: 10000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.height
    }
    

    static func ls_randomStr(len : Int) -> String{
        let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    func ls_isMobile()-> Bool {
        
        
        let phoneRegex = "^((13[0-9])|(17[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@" , phoneRegex)
        
        return (phoneTest.evaluate(with: self));
    }

    
    func ls_length()->Int{
        var length = 0
        for char in self {
         length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2:1
        }
        return length
    }
     
     
     func ls_reduceTo(_ length:Int) -> String{
        var strlength = 0
        var targetLength = 0
        for char in self.enumerated() {
         strlength += "\(char.element)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2:1
         if strlength > length {
             break
         }
         targetLength = char.offset + 1
        }
        return String(self.prefix(targetLength))
     }
     
     
     
     func ls_hasChinese() -> Bool {
         
         for (_, value) in self.enumerated() {
             
             if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                 return true
             }
         }
         
         return false
     }
     

    func ls_intervaltoDateStr(_ format:String = "yyyy-MM-dd") -> String? {
        
        guard let timeInterval = TimeInterval(self) else { return nil }
        let date:Date =  Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    

    func ls_toDate(format:String = "yyyy-MM-dd") -> Date? {
        
        guard let timeInterval = TimeInterval(self) else { return nil }
        let date:Date =  Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    
    var ls_removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    
    var ls_removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    
    
    func ls_roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    var ls_trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var ls_doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    func ls_width(_ font: UIFont, maxHeight: CGFloat, maxWidth: CGFloat = CS_kScreenW) -> CGFloat {
        let tempStr = self as NSString
        return tempStr.boundingRect(with: CGSize.init(width: maxWidth, height: maxHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.width
    }
}

extension String {
    
    static func ls_convertToJsonString(dict: String) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))

            guard let result = String(data: jsonData, encoding: String.Encoding.utf8) else {
                return nil
            }
            
            return result
            
        } catch {
            return nil
        }
    }
    
    static func ls_convertDictionaryToString(dict: [String:Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))

            guard let result = String(data: jsonData, encoding: String.Encoding.utf8) else {
                return nil
            }
            
            return result
            
        } catch {
            return nil
        }
    }
    
    static func ls_convertDictionaryToData(dict: [String:Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            return jsonData
            
        } catch {
            return nil
        }
    }
}

extension String {
    /// 16 -> 10
    /// - Returns: 10
    func ls_hexToDecimal() -> Int {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            // 0-9 begin at 48
            sum = sum * 16 + Int(i) - 48
            // A-Z begin at 65
            if i >= 65 {
                sum -= 7
            }
        }
        return sum
    }
    
    /// 16 -> 10
    /// - Returns: 10
    func ls_hexToDecimalString() -> String {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            // 0-9 begin at 48
            sum = sum * 16 + Int(i) - 48
            // A-Z begin at 65
            if i >= 65 {
                sum -= 7
            }
        }
        return "\(sum)"
    }
    
    /// 10 --> 16
    func ls_decimalToHex(_ hasProfix: Bool = false) -> String {
        guard let decimal = Int(self) else {
            return ""
        }
        if hasProfix {
            return String(format: "0x%0X", decimal)
        } else {
            return String(format: "%0X", decimal)
        }
    }
    
    /// 10 --> 16
    func ls_decimalToHexWithPrefixZeroPadded() -> String {
        guard let decimal = Int(self) else {
            return ""
        }
        var decimalStr = String(format: "%0X", decimal)
        while decimalStr.count < 32 {
            decimalStr = "0\(decimalStr)"
        }
        return "0x\(decimalStr)"
    }
    
    func ls_hexWithPrefixZeroPadded(_ count: Int = 64) -> String {
        var decimalStr = self
        while decimalStr.count < count {
            decimalStr = "0\(decimalStr)"
        }
        return decimalStr
    }
}

extension String {
    static func ls_validateEmail(_ email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
        
    /// password contains number or character; length 6-24
    static func ls_isPasswordRuler(_ password:String) -> Bool {
        let passwordRule = "[0-9A-Za-z]{8,24}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: password) == true {
            return true
        } else {
            return false
        }
    }
        
}

//MARK: subscript
extension String {
    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }
    
    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

