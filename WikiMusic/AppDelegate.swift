//
//  AppDelegate.swift
//  WikiMusic
//
//  Created by Michel Goñi on 30/9/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import UIKit
import UserNotifications
import SpotifyKit
// MARK: SpotifyKit initialization

fileprivate let application = SpotifyManager.SpotifyDeveloperApplication(
    clientId:     "9915a1aed4b64fa08585c4f5fa1aee91",
    clientSecret: "2fc28a29fb994c5e99749f4d139586a7",
    redirectUri:  "AlbumRetriever://callback"
)

// The SpotifyKit helper object that will allow you to perform the queries
let spotifyManager = SpotifyManager(with: application)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        let folder: String = path[0] as! String
        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied")
            }
        }
        
        return true
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        spotifyManager.saveToken(from: url)
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
        
        self.searchAlbumInSPotify(withAlbumName: notification.request.content.userInfo["album"] as! String, andArtistName: notification.request.content.userInfo["artist"] as! String)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
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
    
    //MARK: --Private Spotifykit implementation
    private func searchAlbumInSPotify(withAlbumName albumName: String, andArtistName artistName: String) {
        
        spotifyManager.find(SpotifyAlbum.self, albumName) { tracks in
            
            for track in tracks where track.artist.name == artistName {
                
                print("URI:    \(track.uri), "         +
                    "Name:   \(track.name), "        +
                    "Artist: \(track.artist.name)")
                
                if self.isSpotifyInstalled() {
                    UIApplication.shared.open(NSURL(string:"spotify:album:\(track.uri)")! as URL)
                    
                } else {
                    UIApplication.shared.open(NSURL(string:"https://open.spotify.com/album/\(track.uri)")! as URL)
                }
            }
        }
    }
    
    func isSpotifyInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(NSURL(string:"spotify:")! as URL)
    }

}

