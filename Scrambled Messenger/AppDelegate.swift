//
//  AppDelegate.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 11/19/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hasAuthorizedNotifications: Bool = false
    
    let twitterConsumerKey = "Rp8ZyJRDeGGqNE1mHAAdn8apb"
    let twitterConsumerSecret = "1EZUpqD1J1FV2ed38RGvy2YwAslKhw86Cynr7slYxwDaMTWYJr"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        /**
       Twitter.sharedInstance().start(withConsumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TwitterSignInViewController()
        window?.makeKeyAndVisible()
        **/
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        /** register the notification categories; even if the user denies authorization at the first request, the user may turn on notifications at a later time, at which point the categories should have still been registered so that notifications can be scheduled **/
        
        registerNotificationCategories()

        center.requestAuthorization(options: [.alert, .badge,.sound], completionHandler: {
            
            granted, error in
            
            if(error != nil){
                print("Failed to perform authorization due to error: \(error!.localizedDescription)")
                return
            }
            
            if(granted){
                self.hasAuthorizedNotifications = true
                
                self.addUserInputQuestionNotificationRequest(withRequestIdentifier: "QuestionRequest", withTitle: "Question 1", withSubTitle: "Word is: Happy", withBody: "(a) sad (b) angry (c) elated (d) confused", withSoundFileName: nil, fromNowSeconds: 10, fromNowMinutes: 0, fromNowHours: 0, fromNowDays: 0   )
                
                
            }
            
        })
        
  

        
        
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    enum NotificationCategory: String{
        case FillInTheBlank
        case TrueOrFalse
        case MultipleChoice
        case DictionaryEntry
    }
    
    enum NotificationActionIdentifier: String{
        case HearAudioAction
        case TrueOrFalseChoiceAction
        case DisplayInfoAction
        case MultipleChoiceAction
        case UserInputAction
    }
    
    func registerNotificationCategories(){
        
        let center = UNUserNotificationCenter.current()
        
        
        let displayInfoAction = UNNotificationAction(identifier: NotificationActionIdentifier.DisplayInfoAction.rawValue, title: "Get Information", options: .foreground)
        
        let hearAudioAction = UNNotificationAction(identifier: NotificationActionIdentifier.HearAudioAction.rawValue, title: "Hear Audio Sample", options: .foreground)
        
        let tfChoiceAction = UNNotificationAction(identifier: NotificationActionIdentifier.TrueOrFalseChoiceAction.rawValue, title: "Choose true or false", options: .foreground)
        
        let mcChoiceAction = UNNotificationAction(identifier: NotificationActionIdentifier.MultipleChoiceAction.rawValue, title: "Choose the right option", options: .foreground)
        
        let userInputAction = UNTextInputNotificationAction(identifier: NotificationActionIdentifier.UserInputAction.rawValue, title: "Write the Correct Answer", options: .foreground, textInputButtonTitle: "Enter:", textInputPlaceholder: "write answer here")
        
    
        
        let fillInBlankCategory = UNNotificationCategory(identifier: NotificationCategory.FillInTheBlank.rawValue, actions: [userInputAction], intentIdentifiers: [], options: .customDismissAction)
        
        let multipleChoiceCategory = UNNotificationCategory(identifier: NotificationCategory.MultipleChoice.rawValue, actions: [mcChoiceAction], intentIdentifiers: [], options: .customDismissAction)
        
        let  trueOrFalseCategory = UNNotificationCategory(identifier: NotificationCategory.TrueOrFalse.rawValue, actions: [tfChoiceAction], intentIdentifiers: [], options: .customDismissAction)
        
        
        let wordInformation =  UNNotificationCategory(identifier: NotificationCategory.DictionaryEntry.rawValue, actions: [displayInfoAction,hearAudioAction], intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
        
        center.setNotificationCategories([ fillInBlankCategory,multipleChoiceCategory,trueOrFalseCategory,wordInformation])
    }

    
    
    func addUserInputQuestionNotificationRequest(withRequestIdentifier requestIdentifier: String, withTitle title: String,withSubTitle subtitle: String, withBody body: String, withSoundFileName soundFileName: String?,fromNowSeconds seconds: Int, fromNowMinutes minutes: Int, fromNowHours hours: Int, fromNowDays days: Int){
        
        let request = getUserInputQuestionNotificationRequest(withRequestIdentifier: requestIdentifier,withTitle: title,withSubTitle: subtitle, withBody: body, withSoundFileName: soundFileName, fromNowSeconds: seconds, fromNowMinutes: minutes, fromNowHours: hours, fromNowDays: days)
        
        
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: {
            
            error in
            
            if(error != nil){
                print("Error: failed to add request: \(error!.localizedDescription)")
            }
            
        })
    }
    
    func getUserInputQuestionNotificationRequest(withRequestIdentifier requestIdentifier: String, withTitle title: String, withSubTitle subtitle: String, withBody body: String, withSoundFileName soundFileName: String?,fromNowSeconds seconds: Int, fromNowMinutes minutes: Int, fromNowHours hours: Int, fromNowDays days: Int) -> UNNotificationRequest{
        
        /** Configure the content of the notification **/
        
        let content = UNMutableNotificationContent()
    
        content.categoryIdentifier = NotificationCategory.FillInTheBlank.rawValue
        
        content.sound = soundFileName != nil ?
            UNNotificationSound(named: soundFileName!) : UNNotificationSound.default()
        
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.subtitle = NSString.localizedUserNotificationString(forKey: subtitle, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.body = body
    
        /** Configure the date and time for the notification trigger **/
        
        let currentDate = Date()
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var offsetComponents =  DateComponents()
        
        offsetComponents.second = seconds
        offsetComponents.minute = minutes
        offsetComponents.hour = hours
        offsetComponents.day = days
        
        let targetDate = calendar.date(byAdding: offsetComponents, to: currentDate)!
        
        let targetDateComponents = calendar.dateComponents(Set([Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second,Calendar.Component.year,Calendar.Component.month]), from: targetDate)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: targetDateComponents, repeats: false)
        
        return UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Scrambled_Messenger")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            // The user dismissed the notification without taking action
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // The user launched the app
        }
        
        if response.notification.request.content.categoryIdentifier == NotificationCategory.FillInTheBlank.rawValue {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == NotificationActionIdentifier.UserInputAction.rawValue {
                // Invalidate the old timer and create a new one. . .
                print("User inputted a value")
            }
            else if response.actionIdentifier == NotificationActionIdentifier.HearAudioAction.rawValue  {
                // Invalidate the timer. . .
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}

