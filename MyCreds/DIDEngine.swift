//
//  DIDEngine.swift
//  MyCreds
//
//  Created by tom danner on 6/18/20.
//  Copyright © 2020 tom danner. All rights reserved.
//
import Foundation
import SwiftyJSON
import CryptoSwift
import Alamofire

class DIDEngine {

    public static let shared = DIDEngine()
    
    private let BASE_URL = "http://44.233.202.250:8080/"
    private var deviceToken = ""
    var did: String = "Not Set"
    private var uName: String = ""
    var userName: String = ""
    var credentialWallet: [WalletItem] = []
    var walletVisualization: [WalletVisualizationItem] = []
    var historyList: [HistoryItem] = []
    
    init() {
        loadWalletFromDevice()

        loadHistoryFromDevice()
        createWalletVisualization()
        
        // start the strobe for looking for creds
        Timer.scheduledTimer (timeInterval: 15.0, target: self, selector: #selector(self.checkForCredentials), userInfo: nil, repeats: true)
    }
    
    public func addHistory(relyingParty: String, title: String, date: String) {
        let k = HistoryItem(title: title, relyingParty: relyingParty, date: date)
        historyList.append(k)
        saveHistoryToDevice()
    }
    
    public func registerDevice (token: String) {
        self.deviceToken = token
        print("device token registered: "+deviceToken)
    }
    
    @objc public func checkForCredentials() {
        print("checking for credentials")
        if (did == "Not Set") { return }
        let url = BASE_URL+"v1/wallet/credentials?did="+did
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        AF.request(request).responseString { response in
            let code: Int = response.response?.statusCode ?? 0
            if code == 200 {
                print("success!")
            }
            switch response.result {
                case .success (var value):
                    if code == 200 {
                        value = value.replacingOccurrences(of: "[", with: "")
                        value = value.replacingOccurrences(of: "]", with: "")
                        let jwcs: [String] = value.components(separatedBy: ",")
                        for k: String in jwcs {
                            if self.isNewCred(jwc: k) {
                                self.addJwcToWallet (jwc: k)
                                self.createWalletVisualization()
                            }
                        }
                        self.saveWalletToDevice()
                    }
                    print("success")
                case .failure (let error):
                    print("failure: \(String(describing: error.errorDescription))")
            }  // end of switch
        } // end of response
        
    }
    
    private func isNewCred(jwc: String) -> Bool {
        let parts = jwc.components(separatedBy: ".")
        if parts.count != 3 { return false }
        if let clear = parts[1].fromBase64() {
            let jo = JSON.init(parseJSON: clear)
            let id = jo["id"].string
            var resp = true
            for wi: WalletItem in credentialWallet {
                if wi.id == id {
                    resp = false
                    return resp
                }
            }
            return resp
        }
        return false
    }
    
    private func addJwcToWallet (jwc: String) {
        let wi = WalletItem(jwc: jwc)
        credentialWallet.append(wi)
        print ("wallet size \(credentialWallet.count)")
    }
    
    public func generateQRCode(from string: String) -> UIImage? {
         let data = string.data(using: String.Encoding.ascii)
         if let filter = CIFilter(name: "CIQRCodeGenerator") {
             filter.setValue(data, forKey: "inputMessage")
             let transform = CGAffineTransform(scaleX: 6, y: 6)
             if let output = filter.outputImage?.transformed(by: transform) {
                 return UIImage(ciImage: output)
             }
         }
         return nil
     }
    
    
    func register(userName: String) {
        self.did = "did:alg:"+UUID().uuidString
        self.did = self.did.replacingOccurrences(of: "-", with: "")
        self.userName = userName
        
        createDid()
        sendRegistrationMesage()
        
        
        checkForCredentials()
        createWalletVisualization()
    }
    
    private func createDid() {
        print("TODO - createDid")
    }
    
    private func sendRegistrationMesage() {
        var jo = JSON()
        jo["notificationNetworkType"].string = "apple"
        jo["deviceId"].string = deviceToken
        jo["userName"].string = userName
        jo["did"].string = did
        
        if let message = jo.rawString() {
            let dataMessage = (message.data(using: .utf8))! as Data
            let url = BASE_URL+"v1/wallet/registerDevice"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = dataMessage
        
            AF.request(request).responseJSON { response in
                let code: Int = response.response?.statusCode ?? 0
                if code == 201 {
                    print("item created")
                } else {
                    print("error: \(code)")
                }
            } // end of response
        } // enf of let message
    }
     
    private func saveHistoryToDevice() {
        print ("Saving History")
        var flatDict: [String: String] = [:]
        for k: HistoryItem in historyList {
            let x = flattenHistoryItem(item: k)
            flatDict[x] = x
        }
        let def: UserDefaults = UserDefaults.standard
        def.set(flatDict, forKey: "myHistory")
    }
    
    private func flattenHistoryItem (item: HistoryItem) -> String {
        let k = item.title + "|" + item.relyingParty  + "|" + item.date
        return k
    }
    
    private func loadHistoryFromDevice() {
        print ("Loading history")
        var flatDict: [String: String] = [:]
        let def:UserDefaults = UserDefaults.standard
        let ur:NSDictionary? = def.object(forKey: "myHistory") as? NSDictionary;
        if(ur == nil) {
            flatDict = [:]
        } else {
            flatDict = NSMutableDictionary(dictionary: ur!) as! [String : String]
        }
           
        // with the flatDict in hand recreate the data structure we need for a proper wallet
        historyList = []
        for (_, raw) in flatDict {
            let parts = raw.components(separatedBy: "|")
            let k = HistoryItem (title: parts[0], relyingParty: parts[1], date: parts[2])
            historyList.append(k)
        }  // end of for loop
    }
    
    private func createWalletVisualization() {
        walletVisualization = []
        for wi in credentialWallet {
            let parts = wi.jwc.components(separatedBy: ".")
            if parts.count == 3 {
                var body = parts[1]
                body = body.fromBase64()!
                let jo = JSON.init(parseJSON: body)
                let wvi = WalletVisualizationItem()
                if let degree = jo["dgr"].string {
                    if let rank = jo["rnk"].string {
                        wvi.title = degree + " - " + rank
                    }
                }
                
                if let date = jo["dt"].string { wvi.date = date }
                wvi.issuer = "Ministry of Magic - Dept. of Magical Education"
                walletVisualization.append(wvi)
                
            }
        }
    }
    
    private func makeWalletVisualizationItem(walletItem: WalletItem) -> WalletVisualizationItem {
        return WalletVisualizationItem()
    }
    
   
    
    private func loadWalletFromDevice() {
        print ("Loading wallet")
        var flatDict: [String: String] = [:]
        let def:UserDefaults = UserDefaults.standard
        let ur:NSDictionary? = def.object(forKey: "myCredsWallet") as? NSDictionary;
        if(ur == nil) {
            flatDict = [:]
        } else {
            flatDict = NSMutableDictionary(dictionary: ur!) as! [String : String]
        }
           
        // with the flatDict in hand recreate the data structure we need for a proper wallet
        credentialWallet = []
        for (_, jwc) in flatDict {
            let k = WalletItem(jwc: jwc)
            credentialWallet.append(k)
        }  // end of for loop
    }
    
    private func saveWalletToDevice() {
        print ("Saving Wallet")
        var flatDict: [String: String] = [:]
        for k: WalletItem in credentialWallet {
            flatDict[k.id] = k.jwc
        }
        let def: UserDefaults = UserDefaults.standard
        def.set(flatDict, forKey: "myCredsWallet")
    }
    
    class WalletVisualizationItem {
        var title: String = "Unknown"
        var date: String = "Unknown"
        var issuer: String = "Unknown"
    }
    
    class WalletItem {
        var jwc: String
        var id: String
        
        init(jwc: String) {
            self.jwc = jwc
            self.id="unknown"
            let parts = jwc.components(separatedBy: ".")
            if parts.count == 3 {
                if let raw = parts[1].fromBase64() {
                    let jo = JSON.init(parseJSON: raw)
                    let k: String? = jo["id"].string
                    if  k != nil {
                        id = jo["id"].string!
                    }
                }
            }
        }
    }
    
    class HistoryItem {
        var date: String = ""
        var relyingParty: String = ""
        var title: String = ""
        
        init(title: String, relyingParty: String, date: String) {
            self.date=date
            self.title=title
            self.relyingParty=relyingParty
        }
    }
}

extension String {
        func fromBase64() -> String? {
                guard let data = Data(base64Encoded: self) else {
                        return nil
                }
                return String(data: data, encoding: .utf8)
        }
        func toBase64() -> String {
                return Data(self.utf8).base64EncodedString()
        }
}



