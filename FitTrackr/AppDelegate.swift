//
//  AppDelegate.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/18/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import UIKit
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var locationService: LocationService?
  var dataManager: RunDataManager?



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    
    
    window                      = UIWindow(frame: UIScreen.main.bounds)
    // Set up the first View Controller
    let vc1 = InitialViewController()
    let navBar1 = UINavigationController(rootViewController: vc1)
    navBar1.tabBarItem.title = "Orange"
    navBar1.tabBarItem.image = nil

    
    // Set up the second View Controller
    let vc2 = RunViewController()
    let navBar2 = UINavigationController(rootViewController: vc2)
    navBar2.tabBarItem.title = "Purple"
    navBar2.tabBarItem.image = nil

    
    
    let vc3 = UIViewController()
    vc3.view.backgroundColor = UIColor.blue
    
    let navBar3 = UINavigationController(rootViewController: vc3)
    navBar3.tabBarItem.title = "Blue"
    navBar3.tabBarItem.image = nil

    
    // Set up the Tab Bar Controller to have two tabs
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [navBar1, navBar2, navBar3]
    
    // Make the Tab Bar Controller the root view controller
    window?.rootViewController = tabBarController
    
    locationService = LocationService()
    dataManager = RunDataManager()
    locationService?.delegate = dataManager

    
    
    /*
    let initialVC  = InitialViewController()
   
    let tabBarController = UITabBarController()
    
    let controllers = [initialVC]
    tabBarController.viewControllers = [initialVC]
    
    initialVC.tabBarItem = UITabBarItem(
      title: "Pie",
      image: nil,
      tag: 1)
    
    let feedNavCtrl = UINavigationController(rootViewController: initialVC)
    window.rootViewController  = tabBarController
    print(tabBarController.viewControllers)
    // initialVC.title = "Welcome"
    
    */
    
    window?.makeKeyAndVisible()
    
    

    
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

