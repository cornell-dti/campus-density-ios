//
//  AppDelegate.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var placesViewController: PlacesViewController!
    var locationManager: CLLocationManager!
    var tabBarController: UITabBarController!
    //var gymsViewController: GymsViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.grayishBrown, NSAttributedString.Key.font: UIFont.sixteenBold]

        tabBarController = UITabBarController()

        //Setting up PlacesViewController
        placesViewController = PlacesViewController()
        placesViewController.title = "Eateries"
        placesViewController.tabBarItem = UITabBarItem(title: "Eateries", image: UIImage(named: "food"), tag: 0)
       // placesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        let placesViewNav = UINavigationController(rootViewController: placesViewController)

        //Setting up GymViewController
        let gymsViewController = UINavigationController(rootViewController: GymsViewController())
        gymsViewController.title = "Gyms"
        gymsViewController.tabBarItem = UITabBarItem(title: "Gyms", image: UIImage(named: "fitness"), tag: 1)

        //Adding view controllers to the tab bar
        let controllers = [placesViewNav, gymsViewController]
        tabBarController.viewControllers = controllers as [UIViewController]

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        System.currentUserLocation = manager.location
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
