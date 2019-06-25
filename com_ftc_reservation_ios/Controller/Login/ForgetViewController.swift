//
//  ForgetViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/11.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btn_forgetcancel: UIButton!
    @IBOutlet weak var btn_forgetconfirm: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var communicator = Communicator.shared
    var email = ""
    var phonenumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnshadow(btn:btn_forgetcancel)
        btnshadow(btn:btn_forgetconfirm)
        
        emailTextField.delegate = self
        phoneTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
        email = emailTextField.text!
        phonenumber = phoneTextField.text!
        
        if email == "" || phonenumber == ""{
            alert(message: "請輸入信箱和電話號碼")
        }
        
        //連後端資料庫 Request
        communicator.rpewsdet(email: email, tel: phonenumber){ (data, error) in
            if let error = error {
                print("error:\(error)")
                self.alert(message: "身份驗證失敗")
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
                let codeResult = try decoder.decode(M_Forget.self, from: json)
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPswSend")
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
        let alert = UIAlertController(title: "警告：不可為空白", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "重新輸入", style: .default, handler: {
            action in
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.phoneTextField.becomeFirstResponder()
        }else if textField == phoneTextField {
            phoneTextField.resignFirstResponder()
        }
        return true
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
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            textField.resignFirstResponder()
            phoneTextField.becomeFirstResponder()
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
