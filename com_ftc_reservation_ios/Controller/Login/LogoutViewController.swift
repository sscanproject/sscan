//
//  LogoutViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/11.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    
    @IBOutlet weak var btn_logout: UIButton!
    @IBOutlet weak var btn_outcancel: UIButton!
    
    var communicator = Communicator.shared
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnshadow(btn:btn_logout)
        btnshadow(btn:btn_outcancel)
    }
    
    @IBAction func LogoutConfirmBtn(_ sender: Any) {
        
        let accesstoken = userDefaults.string(forKey: "access_token")
        //連後端資料庫 Request
        communicator.logout(access: accesstoken!){ (data, error) in
            if let error = error {
                print("error:\(error)")
                self.alert(message: "發生錯誤")
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
                let codeResult = try decoder.decode(M_Logout.self, from: json)
                
                
                //接收後端資料庫的Response
                if(codeResult.code == 201){
                    self.alert(message: "已成功登出系統！")
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
    
    @IBAction func LogoutCancelBtn(_ sender: Any) {
        
        //Redirect to new viewcontroler
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogintoHome")
        self.hidesBottomBarWhenPushed = true
        self.show(vc, sender: self)
        
    }
    
    
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確認", style: .default, handler: {
            action in
            
            //Redirect to new viewcontroler
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login")
            self.hidesBottomBarWhenPushed = true
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
    
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
