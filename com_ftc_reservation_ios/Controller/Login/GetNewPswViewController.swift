//
//  GetNewPswViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/12.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class GetNewPswViewController: UIViewController {

    @IBOutlet weak var btn_submit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnshadow(btn: btn_submit)
    }
    

    @IBAction func submitBtn(_ sender: Any) {
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
