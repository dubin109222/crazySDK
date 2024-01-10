//
//  Mnemonic.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/11.
//  Copyright © 2018 yuzushioh. All rights reserved.
//
import Foundation
import CryptoKit

// https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki
public final class Mnemonic {
    public enum Strength: Int {
        case normal = 128
        case hight = 256
    }
    
    public static func create(strength: Strength = .normal, language: WordList = .english) -> String {
        let byteCount = strength.rawValue / 8
        let bytes = Data.hd_randomBytes(length: byteCount)
        return create(entropy: bytes, language: language)
    }
    
    public static func create(entropy: Data, language: WordList = .english) -> String {
        let entropybits = String(entropy.flatMap { ("00000000" + String($0, radix: 2)).suffix(8) })
        let hashBits = String(entropy.sha256().flatMap { ("00000000" + String($0, radix: 2)).suffix(8) })
        let checkSum = String(hashBits.prefix((entropy.count * 8) / 32))
        
        let words = language.words
        let concatenatedBits = entropybits + checkSum
        
        var mnemonic: [String] = []
        for index in 0..<(concatenatedBits.count / 11) {
            let startIndex = concatenatedBits.index(concatenatedBits.startIndex, offsetBy: index * 11)
            let endIndex = concatenatedBits.index(startIndex, offsetBy: 11)
            let wordIndex = Int(strtoul(String(concatenatedBits[startIndex..<endIndex]), nil, 2))
            mnemonic.append(String(words[wordIndex]))
        }
        
        return mnemonic.joined(separator: " ")
    }
    
    public static func createSeed(mnemonic: String, withPassphrase passphrase: String = "") -> Data {
        guard let password = mnemonic.decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
            fatalError("Nomalizing password failed in \(self)")
        }
        
        guard let salt = ("mnemonic" + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
            fatalError("Nomalizing salt failed in \(self)")
        }
        
        return Crypto.PBKDF2SHA512(password: password.bytes, salt: salt.bytes)
    }
    
    public enum WordCount: Int {
        case twelve = 12
        case fifteen = 15
        case eighteen = 18
        case twentyOne = 21
        case twentFour = 24

        var bitLength: Int {
            self.rawValue / 3 * 32
        }

        var checksumLength: Int {
            self.rawValue / 3
        }
    }
    
    public static func isValid(mnemonic: String) -> Bool {
            let mnemonicComponents = mnemonic.components(separatedBy: " ")
            guard !mnemonicComponents.isEmpty else {
                return false
            }

            guard let wordCount = WordCount(rawValue: mnemonicComponents.count) else {
                return false
            }

            // determine the language of the seed or fail
        let language = WordList.english
        let vocabulary = language.words

            // generate indices array
            var seedBits = ""
        for word in mnemonicComponents {
            guard let indexInVocabulary = vocabulary.firstIndex(of: word) else {
                return false
            }

            let binaryString = String(indexInVocabulary, radix: 2).pad(toSize: 11)

            seedBits.append(contentsOf: binaryString)
        }

        let checksumLength = mnemonicComponents.count / 3

        guard checksumLength == wordCount.checksumLength else {
            return false
        }
        let dataBitsLength = seedBits.count - checksumLength

       let dataBits = String(seedBits.prefix(dataBitsLength))
       let checksumBits = String(seedBits.suffix(checksumLength))

       guard let dataBytes = dataBits.bitStringToBytes() else {
           return false
       }

       let hash = SHA256.hash(data: dataBytes)
       let hashBits = hash.bytes.toBitArray().joined(separator: "").prefix(checksumLength)

       guard hashBits == checksumBits else {
           return false
       }
        
        return true

   }
}

extension String {
    func pad(toSize: Int) -> String {
        guard self.count < toSize else { return self }
        var padded = self
        for _ in 0..<(toSize - self.count) {
            padded = "0" + padded
        }
        return padded
    }
    
    /// turns an array of "0"s and "1"s into bytes. fails if count is not modulus of 8
    func bitStringToBytes() -> Data? {
        let length = 8
        guard self.count % length == 0 else {
            return nil
        }
        var data = Data(capacity: self.count)

        for i in 0 ..< self.count / length {
            let startIdx = self.index(self.startIndex, offsetBy: i * length)
            let subArray = self[startIdx ..< self.index(startIdx, offsetBy: length)]
            let subString = String(subArray)
            guard let byte = UInt8(subString, radix: 2) else {
                return nil
            }
            data.append(byte)
        }
        return data
    }
}

public extension UInt8 {
    func mnemonicBits() -> [String] {
        let totalBitsCount = MemoryLayout<UInt8>.size * 8

        var bitsArray = [String](repeating: "0", count: totalBitsCount)

        for j in 0 ..< totalBitsCount {
            let bitVal: UInt8 = 1 << UInt8(totalBitsCount - 1 - j)
            let check = self & bitVal

            if check != 0 {
                bitsArray[j] = "1"
            }
        }
        return bitsArray
    }
}

public extension Data {
    func toBitArray() -> [String] {
        var toReturn = [String]()
        for num in [UInt8](self) {
            toReturn.append(contentsOf: num.mnemonicBits())
        }
        return toReturn
    }
}

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
    var hexString: String {
        bytes.hexString
    }
}

public extension Array where Element == UInt8 {
    func toBitArray() -> [String] {
        var toReturn = [String]()
        for num in self {
            toReturn.append(contentsOf: num.mnemonicBits())
        }
        return toReturn
    }
}

extension Array where Element == UInt8 {
    var hexString: String {
        self.map { String(format: "%02x", $0) }.joined()
    }
}
