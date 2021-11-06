//
//  AppDelegate.swift
//  MYX
//
//  Created by Aman on 08/10/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications


func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        self.checkAuth()
        regiterForFCM(application : application)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        return true
    }

    func regiterForFCM(application : UIApplication){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }


    
    //MARK: check if already login
    func checkAuth(){
        if UserManager.shared.isLoggedIn{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

            // rootViewController
            let rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController

            // navigationController
            let navigationController = UINavigationController(rootViewController: rootViewController!)

            navigationController.isNavigationBarHidden = true // or not, your choice.

            // self.window
            self.window = UIWindow(frame: UIScreen.main.bounds)

            self.window!.rootViewController = navigationController

            self.window!.makeKeyAndVisible()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    
    ///CreateDateForNotification
        func createDate(day: Int, month : Int, hour: Int, minute: Int, year: Int)->Date{

    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    components.year = year
    components.day = day
    components.month = month

    components.timeZone = .current

    let calendar = Calendar(identifier: .gregorian)
    return calendar.date(from: components)!
    }

    ///CreateNitification
    func scheduleNotification(at date: Date, identifierUnic : String, body: String, titles:String) {

       

        
    let triggerWeekly = Calendar.current.dateComponents([.day, .month, .hour,.minute, .year], from: date)

    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

    let content = UNMutableNotificationContent()
    content.title = titles
    content.body = body
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "48Hours"

    let request = UNNotificationRequest(identifier: identifierUnic, content: content, trigger: trigger)
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    UNUserNotificationCenter.current().add(request) {(error) in
    if let error = error {
    print(" We had an error: \(error)")
    }}
        
        
    }
    
}





