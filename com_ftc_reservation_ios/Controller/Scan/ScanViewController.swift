//
//  ScanViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/12.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, LBXScanViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationTitle()
        Scan()
    }
    
    func Scan() {
        print("開始掃描！")
        let vc = QQScanViewController()
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "Controller/Scan/CodeScan.bundle/qrcode_scan_light_green@2x.png")
        vc.scanStyle = style
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        NSLog("scanResult:\(scanResult)")
    }

    func hideNavigationTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
