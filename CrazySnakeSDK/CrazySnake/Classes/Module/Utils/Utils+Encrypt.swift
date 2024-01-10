//
//  Utils+Encrypt.swift
//  Platform
//
//  Created by Lee on 16/12/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import Foundation
//import SwiftyRSA

fileprivate let kRSAPrivateKeyBase64 = "MIIEpQIBAAKCAQEAtXx+nBZz4sAH3hrSTP0eU2YekMBt/WATUyGvd01XmXSRyaYMPrQlDreB0s4URBAFPxiMmmTYGvroM2/tamon+PlMXcYPlzB4mShPkJ3ISK4boj6FeCuXV7ifTmGevDk6s9cLS4YmCdT6eMPMHqblu1luM0KX8dgMNm0LnEm6+WRLb0mYKR+0NuPYJcLog4AgzbG5rIzbsE6xGYPIWbIJn/VJvnK1D5RX1ivKXRB8NaEXalFsyUi+/AA75K6aFigFPEFTt72FdXTsqbWWOT/nG7V6nZe0pJSPnv445r0WcfK8hHYw/ZW+SEAIWPjKUKvFcBdvjIhwwL1pz8c4QU+JrwIDAQABAoIBABadCpGcYpgwYUqVgPrC11KA+PIEaDAYFpBXNCvjYTTnx3qezAvMGon4555Cu1e3v0+bWXmrcxn5hZFTMvv9ejmVpqRQl4S5L222DiPw5RHZT+wpaiwNEnCFuqPjmgnN/7iE5Q1mC7tR5FvD2d0/4oQzon2UoKYry2nEsJuqvDdyx1qQ4ljPa2/GislqvWhd+bHA1nmsmBVP4PN1NxLS6CpzYWlGlYIladAWLl+z6kxtu+pFbHGybsQ3Ta5xl5zKVIdRkqjjSsLvm8G96lrqVq3GwhX5qu75nF58pUiQOdF+OykXRF5x82T7beoAjRIkniwet1gaQVzoVm2lWp7XINECgYEA/f+rZgzbDVb23/xVofelU9xRnNKhtb4q8yTSgLZznTubEKoAcVYili+vdp/n7XTdqCll2O7QahmoI/5ONZ4SSa4QmHkiKhWf17BGMlskDccDzLr/b1qvaDmA5+HtDREx7HAMKuugJJaJfh5GHUW6xGny4JiW+gYUp6j3f0t5N6sCgYEAtuqQL2yHu2cK6//fTJfpiGvfYm5bMu1wOf7IJfeTGUX1KBFfznRSOFru/TfJ4dGAxlejU20ogFBw/PKADb6Pc+bH5j3bIf9jw1xSW4CqYGGAlxo3b1brYbQVDiTN9KIljLMXh11QRKUlvWjUb+OznJ6pXyaNygUHlIHbcFlJIg0CgYEAiHI+GxYw3punB3BAeD/W2pPya7JjGITOAcv4IRjiRsbsaClLD5dcAR4gvjLsno03PczvX3f7EeQyhRNp5DfETzxowd/g0IbJVU7mhsqbNaOBkQuriKBItk6dxvOBKpHgJcmTX8MwRjdwKQYOWE9LI5Re2vRdtnZpxh9oxUNAHP0CgYEAnB3hCAjqZAFTag+OB3JUyLHBC+LChdnvgiA5tWXzr4ts7VC+45eWITFDbu2xqcHE1gQwiuDMw49kkA9tSc3N5A8hqBo9MGwoOrJOPHi5cd9mABFJJQcbiN1JZzP0cIn/4HFucIMtIhmN93ZEcmb2goNMbcCbHcRjLtYSc3ZRG/UCgYEAyOUNX/9bofK8bnHT7QiI1mZxFHhU/asTrtLwZnNUKZiibper6GfCcOVi424+sxlWrsbmgUzvSea6A1EoBEO6tCqCkbNVu5v0rm2EW02Z2iUEX/FIYt0la8jouYL89DAn22Ux2yvBWZGmHfLg2h6sSAFAeZHy84Sg59jJvNNkvcM="

fileprivate let kRSAPublicKeyBase64 = "MIIBCgKCAQEAtXx+nBZz4sAH3hrSTP0eU2YekMBt/WATUyGvd01XmXSRyaYMPrQlDreB0s4URBAFPxiMmmTYGvroM2/tamon+PlMXcYPlzB4mShPkJ3ISK4boj6FeCuXV7ifTmGevDk6s9cLS4YmCdT6eMPMHqblu1luM0KX8dgMNm0LnEm6+WRLb0mYKR+0NuPYJcLog4AgzbG5rIzbsE6xGYPIWbIJn/VJvnK1D5RX1ivKXRB8NaEXalFsyUi+/AA75K6aFigFPEFTt72FdXTsqbWWOT/nG7V6nZe0pJSPnv445r0WcfK8hHYw/ZW+SEAIWPjKUKvFcBdvjIhwwL1pz8c4QU+JrwIDAQAB"

extension Utils {
    
    static func rsa_encrypt(_ content: String) -> (Bool,String) {
        return (true, content.ls_md5)
//        guard let publicKey = try? PublicKey(base64Encoded: kRSAPublicKeyBase64) else {
//            LSLog("!!!!!!rsa_encrypt failed: create public key failed")
//            return (false,"")
//        }
//        guard let clear = try? ClearMessage(string: content, using: .utf8) else {
//            LSLog("!!!!!!rsa_encrypt failed")
//            return (false,"")
//        }
//        guard let encrypted = try? clear.encrypted(with: publicKey, padding: .PKCS1) else {
//            LSLog("!!!!!!rsa_encrypt failed: encrypted failed")
//            return (false,"")
//        }
//
//        // Then you can use:
////        let data = encrypted.data
//        let base64String = encrypted.base64String
//
////        LSLog("encrypted base64String:\(base64String)")
//        return (true, base64String)
    }
    
    static func rsa_decrypt(_ content: String) -> (Bool,String){
        return (true, content.ls_md5)
    }
//    {
//        guard let privateKey = try? PrivateKey(base64Encoded: kRSAPrivateKeyBase64) else {
//            LSLog("!!!!!!rsa_encrypt failed: create private key failed")
//            return (false,"")
//        }
//
//        guard let encrypted = try? EncryptedMessage(base64Encoded: content) else {
//            LSLog("!!!!!!rsa_encrypt failed")
//            return (false,"")
//        }
//        guard let clear = try? encrypted.decrypted(with: privateKey, padding: .PKCS1) else {
//            LSLog("!!!!!!rsa_encrypt failed: decrypted failed")
//            return (false,"")
//        }
//
//        // Then you can use:
////        let data1 = try? clear.data
////        let base64String = clear.base64String
//        guard let string = try? clear.string(encoding: .utf8)else {
//            LSLog("!!!!!!rsa_encrypt failed: format result to string failed")
//            return (false,"")
//        }
//
////        LSLog("decryptData base64String:\(base64String)")
//        LSLog("decryptData result:\(string)")
//        return (true, string)
//    }
    
}
