//
//  File.swift
//  
//
//  Created by Andrew Wang on 2022/5/25.
//

import Foundation
import BigInt

public protocol TypedDataUtilCompatible {
    associatedtype someType
    var typedDataUtil: someType { get }
}

public extension TypedDataUtilCompatible {
    var typedDataUtil: TypedDataUtilHelper<Self> {
        get { return TypedDataUtilHelper(self) }
    }
}

public struct TypedDataUtilHelper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

extension String: TypedDataUtilCompatible {}

extension TypedDataUtilHelper where Base == String {
    
    public var drop0x: String {
        if base.hasPrefix("0x") {
            return String(base.dropFirst(2))
        }
        return base
    }
    
    public var hexDecodedData: Data {
        // Convert to a CString and make sure it has an even number of characters (terminating 0 is included, so we
        // check for uneven!)
        guard let cString = base.cString(using: .ascii), (cString.count % 2) == 1 else {
            return Data()
        }
        
        var result = Data(capacity: (cString.count - 1) / 2)
        for i in stride(from: 0, to: (cString.count - 1), by: 2) {
            guard let l = hexCharToByte(cString[i]), let r = hexCharToByte(cString[i+1]) else {
                return Data()
            }
            var value: UInt8 = (l << 4) | r
            result.append(&value, count: MemoryLayout.size(ofValue: value))
        }
        return result
    }
    
    private func hexCharToByte(_ c: CChar) -> UInt8? {
        if c >= 48 && c <= 57 { // 0 - 9
            return UInt8(c - 48)
        }
        if c >= 97 && c <= 102 { // a - f
            return UInt8(10) + UInt8(c - 97)
        }
        if c >= 65 && c <= 70 { // A - F
            return UInt8(10) + UInt8(c - 65)
        }
        return nil
    }
    
    // range
    var fullRange: Range<Base.Index> {
        return base.startIndex..<base.endIndex
    }
    
    var fullNSRange: NSRange {
        return NSRange(fullRange, in: base)
    }
    
}

extension Data: TypedDataUtilCompatible {}

extension TypedDataUtilHelper where Base == Data {

    /// Returns the hex string representation of the data.
    public var hexString: String {
        return base.map({ String(format: "%02x", $0) }).joined()
    }
    
}

extension BigInt: TypedDataUtilCompatible {}

extension TypedDataUtilHelper where Base == BigInt {
    
    /// Serializes the `BigInt` with the specified bit width.
    ///
    /// - Returns: the serialized data or `nil` if the number doesn't fit in the specified bit width.
    func serialize(bitWidth: Int) -> Data? {
        let valueData = twosComplement()
        if valueData.count > bitWidth {
            return nil
        }
        
        var data = Data()
        if base.sign == .plus {
            data.append(Data(repeating: 0, count: bitWidth - valueData.count))
        } else {
            data.append(Data(repeating: 255, count: bitWidth - valueData.count))
        }
        data.append(valueData)
        return data
    }
    
    // Computes the two's complement for a `BigInt` with 256 bits
    private func twosComplement() -> Data {
        if base.sign == .plus {
            return base.magnitude.serialize()
        }
        
        let serializedLength = base.magnitude.serialize().count
        let max = BigUInt(1) << (serializedLength * 8)
        return (max - base.magnitude).serialize()
    }
    
    var hexEncoded: String {
        return "0x" + String(base, radix: 16)
    }
}
