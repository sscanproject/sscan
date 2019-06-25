//
//  HomePageViewController.swift
//  com_ftc_reservation_ios
//
//  Created by Toby on 2019/4/12.
//  Copyright © 2019 Toby. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var HomeSegmentControl: UISegmentedControl!
    @IBOutlet weak var SummaryView: UIView!
    @IBOutlet weak var ActualView: UIView!
    @IBOutlet weak var ExpectedView: UIView!
    @IBOutlet weak var SearchView: UIView!
    
    let userDefaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SummaryView.isHidden = false
        ActualView.isHidden = true
        ExpectedView.isHidden = true
        SearchView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        hideNavigationTitle()
  
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            SummaryView.isHidden = false
            ActualView.isHidden = true
            ExpectedView.isHidden = true
            SearchView.isHidden = true
            view.endEditing(true)
        case 1:
            SummaryView.isHidden = true
            ActualView.isHidden = false
            ExpectedView.isHidden = true
            SearchView.isHidden = true
            view.endEditing(true)
        case 2:
            SummaryView.isHidden = true
            ActualView.isHidden = true
            ExpectedView.isHidden = false
            SearchView.isHidden = true
            view.endEditing(true)
        case 3:
            SummaryView.isHidden = true
            ActualView.isHidden = true
            ExpectedView.isHidden = true
            SearchView.isHidden = false
        default:
            break;
        }
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
