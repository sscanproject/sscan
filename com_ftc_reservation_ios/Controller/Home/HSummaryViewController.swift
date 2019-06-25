//
//  HSummaryViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/11.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit
import Charts


class HSummaryViewController: UIViewController {
    var communicator = Communicator.shared
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var label_acttitle: UILabel! //研討會名稱
    @IBOutlet weak var label_totalcnt: UILabel! //報名人數
    @IBOutlet weak var label_realcnt: UILabel! //報到人數
    @IBOutlet weak var label_percent: UILabel! //報到百分比
   
    
    var actualDataEnty = PieChartDataEntry(value: 0)
    var notarriveDataEnty = PieChartDataEntry(value:0)
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callPortalApi()
//        self.hideKeyboardWhenTappedAround()
    }
    
    
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
            let backToString = String(data: jsonData, encoding: String.Encoding.utf8) as! String
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
                    
                    //set值到頁面上
                    self.label_acttitle.text = finalResult.title
                    self.label_totalcnt.text = String(finalResult.totalcount)
                    self.label_realcnt.text = String(finalResult.realcount)
                    
                    let signup_percent = Double(finalResult.realcount) / Double(finalResult.totalcount) * 100
                    
                    self.label_percent.text = String(signup_percent.rounded()) + "%"
                    
                    self.pieChart.chartDescription?.text = ""
                    
                    self.actualDataEnty.value = Double(finalResult.realcount)
                    self.actualDataEnty.label = "實到人數"
                    
                    self.notarriveDataEnty.value = Double(finalResult.totalcount - finalResult.realcount)
                    self.notarriveDataEnty.label = "未到人數"
                    
                    self.numberOfDownloadsDataEntries = [self.actualDataEnty, self.notarriveDataEnty]
                    
                    self.updateChartData()
                    
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
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)]
        chartDataSet.colors = colors
        pieChart.data = chartData
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        HSearchViewController().view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        HSearchViewController().view.endEditing(true)
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
