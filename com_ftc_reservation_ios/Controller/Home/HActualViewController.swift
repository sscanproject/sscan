//
//  HActualTableViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/18.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class HActualViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var communicator = Communicator.shared
    let userDefaults = UserDefaults.standard
    var members: [M_Member] = []
    var strCount = ""
    let refreshControl = UIRefreshControl()
    var actxuid: String = ""
    var count = 0
    
    @IBOutlet weak var label_actual: UILabel!
    @IBOutlet weak var tableView_actual: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView_actual.dataSource = self
        tableView_actual.delegate = self
        
        //refreshControl
        if #available(iOS 10.0, *) {
            self.tableView_actual.refreshControl = refreshControl
        } else {
            self.tableView_actual.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(self.actxuid == ""){ //防止ACTXUID空白造成錯誤
            self.callPortalinPageActualApi()
        }
        callSearchByMKApi(actxuid:  userDefaults.string(forKey: "actxuid")!)
        //        self.hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.label_actual.text = "實到人數：" + String(members.count)
        return members.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActualCell", for: indexPath) as! HActualTableViewCell
        let member = members[indexPath.row]
        cell.number.text = member.mbcheckinseq
        cell.name.text = member.mbnm
        cell.tel.text = member.mbtel
        cell.xuid = member.mbxuid
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ActualtoDetail"{
            guard  let targetVC = segue.destination as? HMemberDetailController else {
                assertionFailure("Faild to get destination")
                return
            }
            guard let selectedIndexPath = self.tableView_actual.indexPathForSelectedRow else {
                assertionFailure("failed to get indexpath.")
                return
            }
            targetVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            targetVC.navigationItem.leftItemsSupplementBackButton = true
            targetVC.mbxuid = members[selectedIndexPath.row].mbxuid
            print("targetVC.memberid :\(members[selectedIndexPath.row].mbxuid)")
        }
    }
    
    func callSearchByMKApi(actxuid: String) {
        
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        let searchmk = "Y"
        
        
        //communicator to searchByMK
        communicator.searchbymk(access: accesstoken!, account: acno!, acxuid: actxuid, mbmk: searchmk){ (data, error) in
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
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    
                    let decoder = JSONDecoder()
                    do {
                        
                        let jsondata = try decoder.decode(M_SearchByMk.self, from: json)
                        print(jsondata)
                        self.members = jsondata.mblist
                        
//                        var x : Int = jsondata.mblist.count
//                        var strExceptcount = String(x)
//                        self.strCount = strExceptcount
                        
                    } catch {
                        print(error)
                    }
                    
                }else if(codeResult.code == 403){
                    
                    if(codeResult.message.contains("連線逾時")){
                        self.alertBackLogin(message: codeResult.message)
                        return
                    }
                    
                    self.alert(message: codeResult.message)
                    return
                }
                
                self.tableView_actual.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確認", style: .default, handler: {
            action in
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
    
    func callPortalinPageActualApi() {
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        
        
        //communicator to portal
        communicator.portal(access: accesstoken!, account: acno!){ (data, error) in
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
                let finalResult: M_Portal
                
                //接收後端資料庫的Response
                if(codeResult.code == 200){
                    finalResult = try decoder.decode(M_Portal.self, from: json)
                    self.userDefaults.set(finalResult.actxuid, forKey: "actxuid")
                    self.actxuid = finalResult.actxuid
                    return
                    
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
    
    
    @objc
    func refreshTableViewData(_ sender: Any) {
        callSearchByMKApi(actxuid: userDefaults.string(forKey: "actxuid")!)
        self.refreshControl.endRefreshing()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
