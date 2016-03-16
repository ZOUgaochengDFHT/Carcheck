 //
//  AppDelegate.swift
//  Carcheck
///var/folders/p7/kdq0_hn15xd51j3zcrtnd8zr0000gn/T/AppIconMaker/appicon.png
//  Created by GaoCheng.Zou on 16/2/14.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
//import Crashlytics
//
//func NSLog(format: String, args: CVarArgType...) {
//    #if DEBUG
//        CLSNSLogv(format, getVaList([]))
//    #else
//        CLSLogv(format, getVaList([]))
//    #endif
//}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarVC: ZGCBaseTabBarController!
    
    var notificationWindow: UIWindow!
    
    var userInfo:[NSObject : AnyObject]!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0") == true {
            JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue |
            UIUserNotificationType.Sound.rawValue |
            UIUserNotificationType.Alert.rawValue, categories: nil)
        }else {
            JPUSHService.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge.rawValue |
                UIRemoteNotificationType.Sound.rawValue |
                UIRemoteNotificationType.Alert.rawValue, categories: nil)
        }
        
        JPUSHService.setupWithOption(launchOptions, appKey: appKey, channel: channel, apsForProduction: false)
        
        
        if UserDefault.objectForKey("isLogined") != nil &&  UserDefault.objectForKey("isLogined") as! Bool == true {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            tabBarVC = storyBoard.instantiateInitialViewController() as! ZGCBaseTabBarController
            self.window?.rootViewController = tabBarVC
        }else {
            let loginVC = ZGCLoginViewController()
            self.window?.rootViewController = loginVC
        }
        
        
        
        return true
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        JPUSHService.registerDeviceToken(deviceToken)
        JPUSHService.setAlias(appKey, callbackSelector: "tagsAliasCallback:tags:alias:", object: self)
        
        print("deviceToken\(deviceToken)")
        
        print("RegistrationID\(JPUSHService.registrationID())")
        

    }
    
    ///后台消息推送
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        JPUSHService.handleRemoteNotification(userInfo)
        self.pushViewControllerWithUserInfo(userInfo)

    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
        
        self.userInfo = userInfo

        self.showNotificationStatusBar()

    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        JPUSHService.showLocalNotificationAtFront(notification, identifierKey: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("did Fail To Register For Remote Notifications With Error: %@",
            error)
    }
    
    
    func pushViewControllerWithUserInfo(userinfo:[NSObject : AnyObject]) {
        let stausStr = (userinfo as NSDictionary).objectForKey("status") as! String
        var index = 0
        switch stausStr {
        case "pass":
            index = 3
            break
        case "unpass":
            index = 2
            break
        case "pendding":
            index = 1
            break
        default:
            break
        }
        if index != 0 {
            let titleArr = ["待审核车检", "未通过车检", "已通过车检"]
            let notuploadVC = ZGCNotUploadViewController()
            notuploadVC.hidesBottomBarWhenPushed = true
            notuploadVC.index = index
            notuploadVC.navigationItem.title = titleArr[index - 1]
            //必须使用全局ZGCBaseTabBarController，因为每一次创建的ZGCBaseTabBarController并不相同
            let nav = tabBarVC.viewControllers![0] as! ZGCBaseNavigationController
            let pushVC = nav.topViewController
            pushVC?.navigationController!.pushViewController(notuploadVC, animated: true)
        }
        
       
    }
    
    //当程序处于前台时，自定义推送消息活跃状态栏
    func showNotificationStatusBar () {
        if notificationWindow != nil {
            notificationWindow = nil
        }
        
        notificationWindow = UIWindow(frame: CGRectMake(0, -55, KScreenWidth, 55))
        notificationWindow.backgroundColor = UIColor(patternImage: UIImage(named: "xiaoxi_bg")!)
        notificationWindow.windowLevel = UIWindowLevelAlert
        
        
        let imgView = UIImageView(frame: CGRectMake(15, 8, 40, 40))
        imgView.image = UIImage(named: "chejian_icon")
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        notificationWindow.addSubview(imgView)
        
        let closeBtn = UIButton(frame: CGRectMake(KScreenWidth - 50, 0, 50, 55))
        closeBtn.setImage(UIImage(named: "login_del"), forState: UIControlState.Normal)
        closeBtn.addTarget(self, action: "closeNotificationAction", forControlEvents: UIControlEvents.TouchUpInside)
        notificationWindow.addSubview(closeBtn)
        
        let alertStr = (self.userInfo as NSDictionary).objectForKey("aps")?.objectForKey("alert")
        
        let titleLabel = UILabel(frame: CGRectMake(imgView.right + 15, 8, KScreenWidth - 70 - 50, 40))
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(12.0)
        titleLabel.text = alertStr as? String
        notificationWindow.addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: "openNotificationAction")
        notificationWindow.addGestureRecognizer(tap)
        
        notificationWindow.makeKeyAndVisible()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.notificationWindow.top = 0.0
            }) { (finished) -> Void in
                self.performSelector("hideNotificationStatusBar", withObject: nil, afterDelay: 3.0)
        }
        
    }
    
    func hideNotificationStatusBar () {
        if notificationWindow == nil {
            return
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.notificationWindow.top = -55.0
            }) { (finished) -> Void in
                self.notificationWindow = nil
        }
        

    }
    
    func closeNotificationAction () {
        self.hideNotificationStatusBar()
    }
    
    func  openNotificationAction () {
        self.hideNotificationStatusBar()
        
        self.pushViewControllerWithUserInfo(self.userInfo)
    }
    
    
    ///版本更新
    
    
    

}



