//
//  LoginViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/11.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btn_forgotpw: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    var account = ""
    var psw = ""
    var communicator = Communicator.shared
    let userDefaults = UserDefaults.standard
    var activeField: UITextField?
    
    //取得手機資訊
    let identifierNumber = UIDevice.current.identifierForVendor //裝置token(udid)
    let systemName = UIDevice.current.systemName //手機廠牌
    let modelName = UIDevice.current.modelName //手機型號
    let iosVersion = UIDevice.current.systemVersion //手機iOS版本
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //印出檢查
        //        print("裝置token(udid)：\(String(describing: identifierNumber))")
        //        print("手機廠牌：\(systemName)")
        //        print("手機型號：\(modelName)")
        //        print("手機iOS版本：\(iosVersion)")
        btnshadow(btn:btn_login)
        accountTextField.delegate = self
        pswTextField.delegate = self
        btn_forgotpw.isHidden = true
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideKeyboardWhenTappedAround()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        btn_forgotpw.isHidden = true
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        account = accountTextField.text!
        psw = pswTextField.text!
        
        if account == "" || psw == "" {
            alert(message: "請輸入帳號密碼")
        }
        //連後端資料庫 Request
        communicator.login(account: account, password: psw, uuid: String(describing: identifierNumber), brand: systemName, phonety: "IOS", OS: iosVersion){ (data, error) in
            if let error = error {
                print("error:\(error)")
                self.alert(message: "帳密錯誤")
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
                let codeResult = try decoder.decode(M_Code.self, from: json)
                let finalResult: M_Login
                
                //接收後端資料庫的Response
                if(codeResult.code == 201){
                    finalResult = try decoder.decode(M_Login.self, from: json)
                    self.userDefaults.set(finalResult.access_token, forKey: "access_token")
                    self.userDefaults.set(finalResult.acno, forKey: "acno")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogintoHome")
                    self.show(vc!, sender: self)
                }
                else if(codeResult.code == 403){
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
        let ok = UIAlertAction(title: "重新輸入", style: .default, handler: {
            action in
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func btnshadow(btn:UIButton) {
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
    }
    
    func adjustTextFieldSize(size: CGFloat, textField: UITextField, text: String ) {
        textField.attributedPlaceholder = NSAttributedString.init(string:text, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize:size)])
    }
    
    func adjustTextFieldColor(color: UIColor, textField: UITextField, text: String ) {
        textField.attributedPlaceholder = NSAttributedString.init(string:text, attributes: [
            NSAttributedString.Key.foregroundColor:color])
    }
    

    func textFieldShouldReturn(_ textfield: UITextField) -> Bool{
        if textfield == self.accountTextField {
//            p1s1TextField.resignFirstResponder()
            self.pswTextField.becomeFirstResponder()
        }else if textfield == pswTextField {
            pswTextField.resignFirstResponder()
        }
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



//獲取手機詳細型號
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

