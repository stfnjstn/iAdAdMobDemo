//
//  AdHelper.swift
//
//  Created by STEFAN JOSTEN on 10/07/15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//
// License: MIT License
// GitHub Repository: https://github.com/stfnjstn/iAdAdMobDemo
// Tutorial: developerplayground.net
//
// Helper class to show iAd and Google AdMob interstitial ads. Default is the iAd.
// If a new iAD add is not available an Google AdMob ad will be shown

import UIKit
import iAd
import GoogleMobileAds


class AdHelper: NSObject {
    
    private var iterationsTillPresentAd = 0 // Can be used to show an ad only after a fixed number of iterations
    private var adMobKey = "" // Stores the key provided by google
    private var counter = 0
    private var adMobInterstitial: GADInterstitial!
    
    
    // Initialize iAd and AdMob interstitials ads
    init(presentingViewController: UIViewController, googleAdMobKey: String, iterationsTillPresentInterstitialAd: Int) {
        self.iterationsTillPresentAd = iterationsTillPresentInterstitialAd
        self.adMobKey = googleAdMobKey
        self.adMobInterstitial = GADInterstitial(adUnitID: self.adMobKey)
        presentingViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Manual
    }
    
    // Present the interstitial ads
    func showAds(presentingViewController: UIViewController) {

        // AdMob Cookie handling:
        // Warning: I'm not a lawyer. You have to decide on your own, if this is sufficient
        // Google gives more hints on: http://www.cookiechoices.org
        let adMobTitle = "Cookie usage:"
        let adMobCookieText = "We use device identifiers to personalise content and ads, to provide social media features and to analyse our traffic. We also share such identifiers and other information from your device with our social media, advertising and analytics partners."
        
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("termsAccepted") {
            var alert = UIAlertController(title: adMobTitle, message: adMobCookieText, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)  { _ in
                userDefaults.setBool(true, forKey: "termsAccepted")
                })
            presentingViewController.presentViewController(alert, animated: true, completion: nil)
        }
        
        // Check if ad should be shown
        counter++
        if counter >= iterationsTillPresentAd {
            
            // Try if iAd ad is available
            if presentingViewController.requestInterstitialAdPresentation() {
                counter = 0
                presentingViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.None
                // The ad was used. Prefetch the next one
                preloadIAdInterstitial(presentingViewController)
                
                // Try if the AdMob is available
            } else {
                if adMobInterstitial == nil {
                    // In case the disableAd was called
                    adMobInterstitial = GADInterstitial(adUnitID: self.adMobKey)
                } else {
                    // Present the AdMob ad, if available
                    if (self.adMobInterstitial.isReady) {
                        counter = 0
                        adMobInterstitial!.presentFromRootViewController(presentingViewController)
                        adMobInterstitial = GADInterstitial(adUnitID: self.adMobKey)
                    }
                }
                // Prefetch the next ads
                preloadIAdInterstitial(presentingViewController)
                preloadAdMobInterstitial()
            }
        }
    }
    
    // Disable ads
    func disableAd(presentingViewController: UIViewController) {
        presentingViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.None
        adMobInterstitial = nil
    }
    
    // Prefetch AdMob ads
    private func preloadAdMobInterstitial() {
        var request = GADRequest()
        request.testDevices = ["kGADSimulatorID"] // Needed to show Ads in the simulator
        self.adMobInterstitial.loadRequest(request)
    }
    
    // Prefetch iAd ads
    private func preloadIAdInterstitial(presentingViewController: UIViewController) {
        presentingViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Manual
        UIViewController.prepareInterstitialAds()
    }
    
}

