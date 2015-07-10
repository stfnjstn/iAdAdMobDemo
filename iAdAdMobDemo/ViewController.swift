//
//  ViewController.swift
//  iAdAdMobDemo
//
//  Created by STEFAN JOSTEN on 10/07/15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var adHelper: AdHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        adHelper = AdHelper(presentingViewController: self, googleAdMobKey: "PASTE YOU ADMOB ID HERE", iterationsTillPresentInterstitialAd: 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAd(sender: AnyObject) {
        adHelper.showAds(self)
    }

}

