//
//  AppDelegate.swift
//  Universal
//
//  Created by Mark on 29/09/2019.
//  Copyright © 2019 Sherdle. All rights reserved.
//

import Foundation
import OneSignal
import SafariServices
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADInterstitialDelegate {

    //START OF CONFIGURATION

    static let CONFIG = ""

    /**
     * Layout options
     */
    static let APP_THEME_LIGHT = true
    static let APP_THEME_COLOR = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0)

    static let GRADIENT_ONE = UIColor(red: 0.11, green: 0.38, blue: 0.94, alpha: 1.0)
    static let GRADIENT_TWO = UIColor(red: 0.11, green: 0.73, blue: 0.85, alpha: 1.0)
    static let APP_DRAWER_HEADER = true
    static let MENU_TEXT_COLOR = UIColor.white
    static let MENU_TEXT_COLOR_SECTION = UIColor.lightText
    
    static let WP_ATTACHMENTS_BUTTON = false

    /**
     * About / Texts
     **/
    static let NO_CONNECTION_TEXT = "We weren't able to connect to the server. Make sure you have a working internet connection."
    static let ABOUT_TEXT = "Thank you for downloading our app! \n\nIf you need any help, press the button below to visit our support."
    static let ABOUT_URL = "http://t1tanis.com"
    static let PRIVACY_POLICY_URL = "http://google.com/help"
    //Clearing both your About Text and About URL will hide the about button

    /**
     * Monetization
     **/
    static let INTERSTITIAL_INTERVAL = 5
    static let ADMOB_INTERSTITIAL_ID = ""
    static let BANNER_ADS_ON = false
    static let ADMOB_UNIT_ID = ""
    static let ADMOB_APP_ID = ""
    static let INTERSTITIALS_FOR_WEBVIEW = false

    static let IN_APP_PRODUCT = ""

    /**
     * API Keys
     **/
    static let ONESIGNAL_APP_ID = "05d3f37a-3f65-43e5-983d-9dd69e4e43cf"

    /**
     * WebView & Url opening
     */
    static let OPEN_IN_BROWSER = true
    static let BROWSER_IS_SAFARICONTROLLER = false;
    
    static let OPEN_BROWSER: [String] = []
    static let openTargetBlankSafari = false
    static let WEBVIEW_HIDE_NAVIGATION = true
    
    /**
     * Navigationbar
     */
    static let DISABLED_NAVIGATIONBAR = true
    static let HIDING_NAVIGATIONBAR = true
    static let APP_BAR_SHADOW = true

    //END OF CONFIGURATION
    
    var window: UIWindow?
    var interstitialCount:Int = 0
    var interstitialAd : GADInterstitial?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Ads
        if AppDelegate.BANNER_ADS_ON && !AppDelegate.hasPurchased() {
            let revealController = self.window?.rootViewController as! SWRevealViewController

            GADMobileAds.sharedInstance().start(completionHandler: nil)
            CJPAdMobHelper.sharedInstance().adMobUnitID = AppDelegate.ADMOB_UNIT_ID
            CJPAdMobHelper.sharedInstance().start(with: revealController)
            //UIApplication.sharedApplication.delegate?.window.rootViewController = CJPAdMobHelper.sharedInstance()
            
            // Request test ads on devices you specify. Your test device ID is printed to the console when
            // an ad request is made.
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ (kGADSimulatorID as! String), "YourTestDevice" ]
            
            self.window!.rootViewController = CJPAdMobHelper.sharedInstance()

            revealController.frontViewController.viewDidLoad()
            
        }

        //In App purchases
        if AppDelegate.IN_APP_PRODUCT.count > 0 {
            WBInAppHelper.setProductsList([AppDelegate.IN_APP_PRODUCT])
        }

        // OneSignal/Notifications
        if AppDelegate.ONESIGNAL_APP_ID.count > 0 {
            //self.oneSignal = OneSignal(launchOptions:launchOptions, appId:ONESIGNAL_APP_ID)
            
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

            OneSignal.initWithLaunchOptions(launchOptions,
                                            appId: AppDelegate.ONESIGNAL_APP_ID,
            handleNotificationAction: nil,
            settings: onesignalInitSettings)

            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

            OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            })
        }

        return true
    }
    
    private func application(application:UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken:NSData!) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }

    private func application(application:UIApplication!, didFailToRegisterForRemoteNotificationsWithError error:NSError!) {
        NSLog("Failed to get token, error: %= ", error)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
            
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and we are authorized
                print("Authorized")
            case .denied:
                // Tracking authorization dialog was
                // shown and permission is denied
                print("Denied")
            case .notDetermined:
                // Tracking authorization dialog has not been shown
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
                })
            } else {
                // Fallback on earlier versions
            }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //--- ObjC
    
    @objc
    static func alwaysLightNavigationBar() -> Bool {
        return !AppDelegate.APP_THEME_LIGHT && AppDelegate.DISABLED_NAVIGATIONBAR;
    }
    
    //--- Utility for opening urls
    
    class func openUrl(url:String!, withNavigationController navController:UINavigationController!) {
        if OPEN_IN_BROWSER || (navController == nil) {
            openInBrowser(url: url, withNavigationController: navController)
        } else {
            //Make the header/navbar solid
            if (navController is TabNavigationController) {
                let nc = navController as! TabNavigationController
                nc.enableTransparencyFunctions(enable: false)
            }

            let storyboard:UIStoryboard! = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewSwiftController
            vc.params = [url!]
            navController.pushViewController(vc, animated:true)
        }
    }
    
    class func openInBrowser(url:String!, withNavigationController navController:UINavigationController!) {
        guard let urlV = URL(string: url) else { return }

        if (!BROWSER_IS_SAFARICONTROLLER || (navController == nil)) {
            UIApplication.shared.open(urlV)
        } else {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false;

            let vc = SFSafariViewController(url: urlV, configuration: config)
            navController.present(vc, animated: true)
        }
    }
    
    //-- Interstitials

    func reloadInterstitialAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AppDelegate.ADMOB_INTERSTITIAL_ID)
        interstitial.delegate = self
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        interstitial.load(request)
        return interstitial
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(ad) did fail to receive ad with error \(error)")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitialAd = reloadInterstitialAd()
    }
    
    func showInterstitial(controller: UIViewController) {
        if shouldShowInterstitial() && self.interstitialAd?.isReady ?? false {
            self.interstitialAd?.present(fromRootViewController: self.window!.rootViewController!)
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.interstitialAd = ad
    }
    
    func interstitialsEnabled() -> Bool {
        if AppDelegate.ADMOB_INTERSTITIAL_ID.count == 0 {return false}
        if AppDelegate.INTERSTITIAL_INTERVAL == 0 {return false}
        if AppDelegate.hasPurchased() {return false}
        
        return true;
    }

    func shouldShowInterstitial() -> Bool {
        if !interstitialsEnabled() { return false }
        
        if self.interstitialAd == nil { self.interstitialAd = reloadInterstitialAd() }
        
        var shouldShowInterstitial = false
        if interstitialCount == AppDelegate.INTERSTITIAL_INTERVAL {
            shouldShowInterstitial = true
            interstitialCount = 0
        }

        interstitialCount += 1
        return shouldShowInterstitial
    }

    class func hasPurchased() -> Bool {
        if IN_APP_PRODUCT.count == 0 {return false}

        return WBInAppHelper.isProductPaid(IN_APP_PRODUCT)
    }

    let userId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
    
}
