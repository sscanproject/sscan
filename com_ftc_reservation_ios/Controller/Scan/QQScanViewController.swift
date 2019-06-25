//
//  QQScanViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/16.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class QQScanViewController: LBXScanViewController {
    
    /**
     @brief  扫码区域上方提示文字
     */
    var topTitle: UILabel?
    
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false
    
    
    //底部显示的功能项
    var bottomItemsView: UIView?
    
    //闪光灯
    var btnFlash: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        drawBottomItems()
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }
        
        let result: LBXScanResult = arrayResult[0]
        
        let vc = ScanResultController()
        vc.codeResult = result
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func drawBottomItems() {
        if (bottomItemsView != nil) {
            
            return
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        
        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100 ) )
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        let size = CGSize(width: 65, height: 87)
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
        
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControl.Event.touchUpInside)
        
        bottomItemsView?.addSubview(btnFlash)
        
        self.view .addSubview(bottomItemsView!)
        
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
            
        }
    }
    
//    @objc func myCode() {
//        let vc = MyCodeViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
