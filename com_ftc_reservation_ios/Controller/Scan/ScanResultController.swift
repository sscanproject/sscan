//
//  ScanResultController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/16.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class ScanResultController: UIViewController {
    
    //按鈕 ref
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_check: UIButton!
    //頁面label ref
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var duty: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var live: UILabel!
    
    var communicator = Communicator.shared
    let userDefaults = UserDefaults.standard
    
    
    var mbxuid : String = ""
    var codeResult: LBXScanResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let origincode = (codeResult?.strScanned)!
        callQrscanApi(origincode: origincode)
        
        btnshadow(btn:btn_cancel)
        btnshadow(btn:btn_check)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let origincode = (codeResult?.strScanned)!
        callQrscanApi(origincode: origincode)
    }
    
    
    @IBAction func MbCheckBtn(_ sender: Any) {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let origincode = (codeResult?.strScanned)!
        let originarray = origincode.components(separatedBy: "_")
        let actxuid = originarray[0]
        
        //communicator to scanok
        communicator.scanok(access: accesstoken!, account: acno!, acxuid: actxuid, mbxuid: self.mbxuid){
            (data, error) in
            if let error = error {
                print("error:\(error)")
                
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                return
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
                assertionFailure("failed to get data")
                return
            }
            
            //中文字處理decode須先轉UTF8避免出錯
            let backToString = String(data: jsonData, encoding: String.Encoding.utf8) as! String
            let json = backToString.data(using: .utf8)!
            do {
                
                let decoder = JSONDecoder()
                decoder.dataDecodingStrategy = .base64
                let codeResult = try decoder.decode(M_ScanOK.self, from: json)
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    self.alert(message: "報到成功！")
                    return
                    
                }else if(codeResult.code == 403){
                    self.alert(message: codeResult.message)
                    return
                }
                
            } catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func MbCancelBtn(_ sender: Any) {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let origincode = (codeResult?.strScanned)!
        let originarray = origincode.components(separatedBy: "_")
        let actxuid = originarray[0]
        
        //communicator to scanok
        communicator.mbchkcancel(access: accesstoken!, account: acno!, acxuid: actxuid, mbxuid: self.mbxuid){
            (data, error) in
            if let error = error {
                print("error:\(error)")
                
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                return
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
                assertionFailure("failed to get data")
                return
            }
            
            //中文字處理decode須先轉UTF8避免出錯
            let backToString = String(data: jsonData, encoding: String.Encoding.utf8) as! String
            let json = backToString.data(using: .utf8)!
            do {
                
                let decoder = JSONDecoder()
                decoder.dataDecodingStrategy = .base64
                let codeResult = try decoder.decode(M_MemberCancel.self, from: json)
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    self.alert(message: "取消報到成功！")
                    return
                    
                }else if(codeResult.code == 403){
                    self.alert(message: codeResult.message)
                    return
                }
                
            } catch {
                print(error)
            }
        }
        
    }
    
    
    func callQrscanApi(origincode: String) {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let oricode = origincode
        let originarray = oricode.components(separatedBy: "_")
        let actxuid = originarray[0]
        let qrcode = originarray[1]
        
        //communicator to qrscan
        communicator.scanqr(access: accesstoken!, account: acno!, acxuid: actxuid, qrcode: qrcode){
            (data, error) in
            if let error = error {
                print("error:\(error)")
                
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                return
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
                assertionFailure("failed to get data")
                return
            }
            
            //中文字處理decode須先轉UTF8避免出錯
            var backToString = String(data: jsonData, encoding: String.Encoding.utf8) as! String
            let json = backToString.data(using: .utf8)!
            do {
                
                let decoder = JSONDecoder()
                decoder.dataDecodingStrategy = .base64
                let codeResult = try decoder.decode(M_Code.self, from: json)
                let finalResult: M_QRcode
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    finalResult = try decoder.decode(M_QRcode.self, from: json)
                    self.mbxuid = finalResult.mbxuid
                    //set值到頁面上
                    self.name.text = "姓名：" + finalResult.mbnm
                    self.company.text = "單位：" + finalResult.mbco
                    self.duty.text = "職稱：" + finalResult.mbdut
                    self.tel.text = "聯絡電話：" + finalResult.mbtel
                    self.email.text = "Email：" + finalResult.mbemail
                    self.live.text = "住宿選項：" + finalResult.livetype
                    self.number.text = "報名序號：" + finalResult.mbno
                    
                    let mbmk = finalResult.mbmk
                    if(mbmk == "Y"){ //已報到過
                        self.number.text = "報名序號：" + finalResult.mbno + " (已報到)"
                       self.btn_cancel.isHidden = false
                       self.btn_check.isHidden = true
                    }else{
                        self.btn_cancel.isHidden = true
                        self.btn_check.isHidden = false
                    }
                    
                }else if(codeResult.code == 403){
                    
                    if(codeResult.message.contains("連線逾時")){
                        self.alertBackLogin(message: codeResult.message)
                        return
                    }
                    
                    self.alert(message: codeResult.message)
                    return
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確認", style: .default, handler: {
            action in
            
        //Redirect to new viewcontroler
        let vc = ScanViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertBackLogin(message:String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確認", style: .default, handler: {
            action in
            
            //Redirect to new viewcontroler
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login")
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
            
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func btnshadow(btn:UIButton) {
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func zoomRect( rect:inout CGRect, srcImg: UIImage) {
        rect.origin.x -= 10
        rect.origin.y -= 10
        rect.size.width += 20
        rect.size.height += 20
        
        if rect.origin.x < 0 {
            rect.origin.x = 0
        }
        
        if (rect.origin.y < 0) {
            rect.origin.y = 0
        }
        
        if (rect.origin.x + rect.size.width) > srcImg.size.width {
            rect.size.width = srcImg.size.width - rect.origin.x - 1
        }
        
        if (rect.origin.y + rect.size.height) > srcImg.size.height {
            rect.size.height = srcImg.size.height - rect.origin.y - 1
        }
        
    }
}
