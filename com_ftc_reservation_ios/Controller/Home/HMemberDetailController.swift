//
//  HExceptedDetailController.swift
//  com_ftc_reservation_ios
//
//  Created by Vicki-Apple on 2019/4/24.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class HMemberDetailController: UIViewController {
    
    @IBOutlet weak var btn_checkin: UIButton!
    @IBOutlet weak var btn_checkout: UIButton!
    
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
    var mbxuid: String?
    var mbtel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnshadow(btn:btn_checkin)
        btnshadow(btn:btn_checkout)
        
//        let tap_tel = UITapGestureRecognizer(target: self, action: #selector(HMemberDetailController.tapFunction))
//        tel.isUserInteractionEnabled = true
//        tel.addGestureRecognizer(tap_tel)
        
        
    }
    
//    @objc
//    func tapFunction(sender:UITapGestureRecognizer) {
//        let urlString = "tel://\(String(describing: mbtel))"
//        if let url = URL(string: urlString) {
//            //根据iOS系统版本，分别处理
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url, options: [:],
//                                          completionHandler: {
//                                            (success) in
//                })
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//
//        print("tap working")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callMbdetailApi(mbxuid: self.mbxuid!)
    }
    
    @IBAction func clickTelephone(_ sender: Any) {
        let urlString = "tel://\(String(describing: mbtel))"
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        print("tap working")
    }
    
    @IBAction func clickCheckin(_ sender: Any) {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let actxuid = userDefaults.string(forKey: "actxuid")!
        let mbxuid = self.mbxuid!
        
        //communicator to scanok
        communicator.scanok(access: accesstoken!, account: acno!, acxuid: actxuid, mbxuid: mbxuid){
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
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func MbCancelBtn(_ sender: Any) {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let actxuid = userDefaults.string(forKey: "actxuid")!
        let mbxuid = self.mbxuid!
        
        //communicator to scanok
        communicator.mbchkcancel(access: accesstoken!, account: acno!, acxuid: actxuid, mbxuid: mbxuid){
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
    
    
    func callMbdetailApi(mbxuid: String) {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let actxuid = userDefaults.string(forKey: "actxuid")
        //communicator to qrscan
        communicator.mbdtl(access: accesstoken!, account: acno!, acxuid: actxuid!, mbxuid: mbxuid){
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
                let finalResult: M_MemberDetail
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    finalResult = try decoder.decode(M_MemberDetail.self, from: json)
                    self.mbxuid = finalResult.mbxuid
                    //set值到頁面上
                    self.name.text = "姓名：" + finalResult.mbnm
                    self.company.text = "單位：" + finalResult.mbco
                    self.duty.text = "職稱：" + finalResult.mbdut
                    self.tel.text = "聯絡電話：" + finalResult.mbtel
//                    self.tel.attributedText = NSAttributedString(string: "聯絡電話：" + finalResult.mbtel, attributes:[.underlineStyle: NSUnderlineStyle.single.rawValue])
                    
                    self.email.text = "Email：" + finalResult.mbemail
                    self.live.text = "住宿選項：" + finalResult.livetype
                    self.number.text = "報名序號：" + finalResult.mbno
                    
                    let mbmk = finalResult.mbmk
                    self.mbtel = finalResult.mbtel
                    
                    if(mbmk == "Y"){ //已報到過
                        self.number.text = "報名序號：" + finalResult.mbno + " (已報到)"
                        self.btn_checkout.isHidden = false
                        self.btn_checkin.isHidden = true
                    }else{
                        self.btn_checkout.isHidden = true
                        self.btn_checkin.isHidden = false
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
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
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
