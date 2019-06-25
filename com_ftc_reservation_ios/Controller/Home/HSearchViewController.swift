//
//  HSearchViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/12.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class HSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView_search: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var communicator = Communicator.shared
    let userDefaults = UserDefaults.standard
    var searchController: UISearchController!
    
    var dataList = [String]() // 預設資料集合資料集合
    var filterDataList: [String] = [String]() // 搜尋結果集合
    var searchedDataSource = [String] () // 被搜尋的資料集合
    var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    var searchresult: [M_Member] = []
    var srhcont = "";
    var actxuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // 生成SearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self // 遵守UISearchBarDelegate協議
        searchbar.showsCancelButton = true
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        tableView_search.dataSource = self
        tableView_search.delegate = self
        
        // 將searchBar掛載到tableView上
        //        self.tableView.tableHeaderView = self.searchController.searchBar
        
        searchbar.delegate = self
        callPortalApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      view.endEditing(true)
    }
    
    
    // MARK: - TableView DataSource
    // ---------------------------------------------------------------------
    // 設定表格section的列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchresult.count
    }
    
    //表格的儲存格設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! HSearchTableViewCell
        let member = searchresult[indexPath.row]
        cell.name.text = member.mbnm
        cell.tel.text = member.mbtel
        cell.number.text = member.mbcheckinseq
        cell.xuid = member.mbxuid
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchtoDetail"{
            guard  let targetVC = segue.destination as? HMemberDetailController else {
                assertionFailure("Faild to get destination")
                return
            }
            guard let selectedIndexPath = self.tableView_search.indexPathForSelectedRow else {
                assertionFailure("failed to get indexpath.")
                return
            }
            view.endEditing(true)
            targetVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            targetVC.navigationItem.leftItemsSupplementBackButton = true
            targetVC.mbxuid = searchresult[selectedIndexPath.row].mbxuid
            print("targetVC.memberid :\(searchresult[selectedIndexPath.row].mbxuid)")
        }
    }
    
    // MARK: - Search Bar Delegate
    // ---------------------------------------------------------------------
    
    // 當在searchBar上開始輸入文字時
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchbar.showsCancelButton = true
    }
    
    // 點擊searchBar上的取消按鈕
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchresult = []
        self.tableView_search.reloadData()
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需要執行查詢的動作，因在「輸入文字時」即會觸發 updateSearchResults 的 delegate 做查詢的動作(可依個人需求決定如何實作)
        
        if searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return
        }
        srhcont = (searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
        callSearchApi(srhcont: srhcont)
        
    }
    
    
    // MARK: - Search Controller Delegate
    // ---------------------------------------------------------------------
    // 當在searchBar上開始輸入文字時
    // 當「準備要在searchBar輸入文字時」、「輸入文字時」、「取消時」三個事件都會觸發該delegate
    //    func updateSearchResults(for searchController: UISearchController) {
    //            self.filterDataSource()
    //    }
    
    //    // 過濾被搜陣列裡的資料
    //    func filterDataSource() {
    //        // 使用高階函數來過濾掉陣列裡的資料
    //        self.filterDataList = searchedDataSource.filter({ (searchresult) -> Bool in
    //            return searchresult.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
    //        })
    //
    //        if self.filterDataList.count > 0 {
    //            self.isShowSearchResult = true
    //            self.tableView_search.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
    //        } else {
    //            self.tableView_search.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
    //            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
    //            // ...
    //        }
    //
    //        self.tableView_search.reloadData()
    //    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    //取首頁ACTXUID
    func callPortalApi() {
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
                    
                }else if(codeResult.code == 403){
                    self.alert(message: codeResult.message)
                    return
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func callSearchApi(srhcont: String) {
        
        let accesstoken = userDefaults.string(forKey: "access_token")
        let acno = userDefaults.string(forKey: "acno")
        //        let actxuid = self.actxuid
        let actxuid = userDefaults.string(forKey: "actxuid")!
        
        //communicator to searchByMK
        communicator.search(access: accesstoken!, account: acno!, acxuid: actxuid, condition: srhcont){ (data, error) in
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
                        
                        if(codeResult.message != ""){
                            self.alert(message: codeResult.message)
                            return
                        }else{
                        
                        let jsondata = try decoder.decode(M_Search.self, from: json)
                        print(jsondata)
                        self.searchresult = jsondata.mblist
                        
                        self.isShowSearchResult = true
                        }
                        
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
                
                self.tableView_search.reloadData()
                
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
