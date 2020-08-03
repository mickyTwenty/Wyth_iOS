//
//  CryptoHelper.swift
//  ActivityTracker
//
//  Created by Malik Wahaj Ahmed on 27/08/2018.
//  Copyright © 2018 Malik Wahaj Ahmed. All rights reserved.
//

import UIKit
import CryptoSwift


class CryptoHelper: NSObject
{
    
    // MARK: - AES Encryption / Decryption Methods
    
    static let kEncryptionKey = "57238004e784498bbc2f8bf984565090"
    
    class func testEncryption() {
        
        let str:String = "Abc12345"
        print("STRING: \(str)")
        
        let data = CryptoHelper.aesEncrypt(str)
        print("ENCRYPTED: \(data)")
        
        let output = CryptoHelper.aesDecrypt(data)
        print("DECRYPTED: \(output)")
        
    }
    
    class func convertHexStringToData(_ hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    
    class func aesEncrypt(_ input:String) -> String {
        
        let keyData = CryptoHelper.convertHexStringToData(CryptoHelper.kEncryptionKey)
        
        let keyArrayBytes = keyData.bytes
        let data = input.data(using: String.Encoding.utf8)
        
        let dataArrayBytes = data?.bytes
        
        do {
            
            let aes = try AES(key: keyArrayBytes, blockMode: CBC(iv: keyArrayBytes) , padding: .pkcs7).encrypt(dataArrayBytes!)
            
            let encData = Data(bytes: UnsafePointer<UInt8>(aes), count: Int(aes.count))
            
            print("enc data \(encData)");
            let encHex = encData.toHexString()
            
            
            return encHex
            
        }
        catch let error {
            print(error)
            
            return "Error"
        }
    }
    
    class func aesDecrypt(_ encryptedHex:String) -> String {
        
        let keyData = CryptoHelper.convertHexStringToData(CryptoHelper.kEncryptionKey)
        
        let keyArrayBytes = keyData.bytes
        
        let data = CryptoHelper.convertHexStringToData(encryptedHex)
        
        let dataArrayBytes = data.bytes
        
        do {
            let dec = try AES(key: keyArrayBytes, blockMode: CBC(iv: keyArrayBytes)).decrypt(dataArrayBytes)
            
            let decData = Data(bytes: UnsafePointer<UInt8>(dec), count: Int(dec.count))
            let result = NSString(data: decData, encoding: String.Encoding.utf8.rawValue)
            return String(result ?? "")
        }
        catch let error {
            print(error)
            return "Error"
        }
    }
}
