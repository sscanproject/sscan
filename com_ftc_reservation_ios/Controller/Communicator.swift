//
//  File.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/12.
//  Copyright © 2019 Toby. All rights reserved.
//

import Foundation
import Alamofire

class Communicator {
    static let testIP = "220.229.239.5"
    static let formalIP = "www.wjy.org.tw"

//    static let BASEURL = "http://\(testIP)/j20rappws"
    static let BASEURL = "http://\(formalIP)/j20rappwsWAR"
//    static let BASEURL = "http://\(formalIP)/j20rappws"

    
    static let shared = Communicator()
    
    let LOGIN_URL = BASEURL + "/login"
    let PORTAL_URL = BASEURL + "/portal"
    let RPEWSDET_URL = BASEURL + "/rpewsdet"
    let SEARCH_URL = BASEURL + "/search"
    let MBCHECK_URL = BASEURL + "/mbchkok"
    let MBCANCEL_URL = BASEURL + "/mbchkcancel"
    let SEARCHBYMK_URL = BASEURL + "/searchbymk"
    let SCANQ_URL = BASEURL + "/quickscan"
    let SCAN_URL = BASEURL + "/qrscan"
    let SCANOK_URL = BASEURL + "/scanok"
    let LOGOUT_URL = BASEURL + "/logout"
    
    let MBDETAIL_URL = BASEURL + "/mbdtl"
    
    private init(){}
    
    //login & logout
    let ACCOUNT_KEY = "acno"
    let PASSWORD_KRY = "pswd"
    let UUID_KEY = "devicetoken"
    let BRAND_KEY = "phonebrand"
    let PONETY_KEY = "phonety"
    let OS_KEY = "phoneosver"
    //portal
    let ACCESS_KEY = "access_token"
    //rpewsdet
    let EMAIL_KEY = "email"
    let TEL_KEY = "acttel"
    //search
    let ACXUID_KEY = "actxuid"
    let SEARCHCON_KEY = "srhcont"
    //mbchkok & mbchkcancel & mbdtl
    let MBXUID_KEY = "mbxuid"
    //searchbymk
    let MBMK_KEY = "mbmk"
    //quickscan & qrscan & scanok
    let QRCODE_KEY = "qrcode"
    
    
    typealias DoneHandler = (_ result: Any? , _ error: Error?) -> Void
    typealias DownloadDoneHandler = (_ result: Data?, _ error: Error?) -> Void
    
    
    func login(account: String, password: String, uuid: String, brand: String, phonety: String, OS: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCOUNT_KEY : account,
                                          PASSWORD_KRY: password,
                                          UUID_KEY: uuid,
                                          BRAND_KEY: brand,
                                          PONETY_KEY: phonety,
                                          OS_KEY: OS]
        doPost(url: LOGIN_URL, parameters: parameters, completion: completion)
        print("login parameters:\(parameters)")
    }
    
    func portal(access: String, account: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account]
        doPost(url: PORTAL_URL, parameters: parameters, completion: completion)
        print("portal parameters:\(parameters)")
    }
    
    func rpewsdet(email: String,tel: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [EMAIL_KEY : email,
                                          TEL_KEY: tel]
        doPost(url: RPEWSDET_URL, parameters: parameters, completion: completion)
        print("rpewsdet parameters:\(parameters)")
    }
    
    func search(access: String, account: String, acxuid:String, condition:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          SEARCHCON_KEY:condition]
        doPost(url: SEARCH_URL, parameters: parameters, completion: completion)
        print("search parameters:\(parameters)")
    }
    
    func mbchk(access: String, account: String, acxuid:String, mbxuid:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          MBXUID_KEY: mbxuid]
        doPost(url: MBCHECK_URL, parameters: parameters, completion: completion)
        print("mbchkok parameters:\(parameters)")
    }
    
    func mbchkcancel(access: String, account: String, acxuid:String, mbxuid:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          MBXUID_KEY: mbxuid]
        doPost(url: MBCANCEL_URL, parameters: parameters, completion: completion)
        print("mbchkcancel parameters:\(parameters)")
    }
    
    func searchbymk(access: String, account: String, acxuid:String, mbmk:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          MBMK_KEY: mbmk]
        doPost(url: SEARCHBYMK_URL, parameters: parameters, completion: completion)
        print("searchbymk parameters:\(parameters)")
    }
    
    func mbdtl(access: String, account: String, acxuid:String, mbxuid:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          MBXUID_KEY: mbxuid]
        doPost(url: MBDETAIL_URL, parameters: parameters, completion: completion)
        print("mbdtl parameters:\(parameters)")
    }
//    func mbdtl_test(access: String, account: String, acxuid:String, mbxuid:String, completion: @escaping DoneHandler) {
//        let parameters: [String : Any] = [ACCESS_KEY : access,
//                                          ACCOUNT_KEY : account,
//                                          ACXUID_KEY: acxuid,
//                                          MBXUID_KEY: mbxuid]
//        doPost(url: MBDETAIL_URL2, parameters: parameters, completion: completion)
//        print("mbdtl_test parameters:\(parameters)")
//    }
    
    func scanquick(access: String, account: String, acxuid:String, qrcode:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          QRCODE_KEY: qrcode]
        doPost(url: SCANQ_URL, parameters: parameters, completion: completion)
        print("scanquick parameters:\(parameters)")
    }
    
    func scanqr(access: String, account: String, acxuid:String, qrcode:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          QRCODE_KEY: qrcode]
        doPost(url: SCAN_URL, parameters: parameters, completion: completion)
        print("scanqr parameters:\(parameters)")
    }
    
    func scanok(access: String, account: String, acxuid:String, mbxuid:String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access,
                                          ACCOUNT_KEY : account,
                                          ACXUID_KEY: acxuid,
                                          MBXUID_KEY: mbxuid]
        doPost(url: SCANOK_URL, parameters: parameters, completion: completion)
        print("scanok parameters:\(parameters)")
    }
    
    func logout(access: String, completion: @escaping DoneHandler) {
        let parameters: [String : Any] = [ACCESS_KEY : access]
        doPost(url: LOGOUT_URL, parameters: parameters, completion: completion)
        print("logout parameters:\(parameters)")
    }
    
    
    
    
    func doPost(url: String, parameters:[String : Any]?, completion: @escaping DoneHandler ){
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            self.handleJson(response: response, completion: completion)
        })
        
    }
    
    func handleJson(response: DataResponse<Any>, completion: DoneHandler) {
        
        print("response:\(response)")
        switch response.result {
            
        case .success(let json):
            print("Get success response: \(json)")
            completion(json,nil)
            
        case .failure( let error):
            print("Server respond error:\(error)")
            completion(nil, error)
        }
    }
   
    
    
    
    
    
    
}
