//
//  ViewController.swift
//  WikiMusic
//
//  Created by Michel Goñi on 30/9/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let dataProvider = LocalCoreDataService()

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        // First thing: scrape records year by year
        //self.scrapeYearByYearRecords()
     
        //second thing: insert local notifications
       //self.scheduleLocal()
        
    }
    

    func scheduleLocal() {
        
        let actualMonthAndrandomYear = (month: DateFormatter().stringMonthFormatter().string(from: Date()), randomYear: Array(1992...1992).randomItem())
        
        //get albums using random year and the actual month
        
        guard let albums = self.dataProvider.getAlbums(withYear: actualMonthAndrandomYear.month, andMonth: String(describing: actualMonthAndrandomYear.randomYear!)) else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM/d/yyyy"
        
        
        for album in albums {
            
            self.scheduleNotification(at: dateFormatter.date(from: album.dateforNotifications!)!, withAlbum: album)
            
        }
    }
    
    func scheduleNotification(at date: Date, withAlbum album: Album) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)

        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year:Calendar.current.component(.year, from: Date()), month: components.month, day: components.day, hour: 18, minute: 30)

        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "One day like today but in \(album.year!)"
        content.body = "\(album.artist!) released \(album.albumName!)"
        content.sound = UNNotificationSound.default()
        content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
        content.userInfo = ["album": album.albumName!, "artist":album.artist!]
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Yikes! We had an error: \(error.localizedDescription)")
            }
        }
    }
    
    func scrapeYearByYearRecords() -> Void {

        Alamofire.request("https://en.wikipedia.org/wiki/1988_in_music#January_.E2.80.93_March").responseString { response in
           
            if let html = response.result.value, let doc = HTML(html: html, encoding: .utf8) {
                var month = ""
                var day = ""
                var recordsDict: [String: String] = [:]
                var finalRecordsDictForCoreData: [String: [String: String]] = [:]
                
                for headline in doc.xpath("//table[@class='wikitable']/tr") {
                    
                   print(headline.xpath("td").count)
                    
                    switch headline.xpath("td").count {

                    case 3:
                        recordsDict["Month"] = month
                        recordsDict["Day"] = day
                        recordsDict["Album"] = headline.xpath("td")[0].content
                        recordsDict["Artist"] = headline.xpath("td")[1].content
                        finalRecordsDictForCoreData[Constants.Years.kYear] = recordsDict
                        self.dataProvider.insertAlbum(albumToinsert: finalRecordsDictForCoreData)
                      
                        break
                    case 4:
                        if  headline.xpath("td")[0].content != "?" {
                            recordsDict["Month"] = month
                            recordsDict["Day"] = headline.xpath("td")[0].content!
                            recordsDict["Album"] = headline.xpath("td")[1].content
                            recordsDict["Artist"] = headline.xpath("td")[2].content
                            finalRecordsDictForCoreData[Constants.Years.kYear] = recordsDict
                            day = headline.xpath("td")[0].content!
                            self.dataProvider.insertAlbum(albumToinsert: finalRecordsDictForCoreData)
                            break
                        }else{
                            print("Skipin insertin n core data simce there´s some error")
                        }
                        
                    case 5:
                        
                        if  headline.xpath("td")[1].content != "?"{
                            
                            recordsDict["Month"] = headline.xpath("td")[0].content?.replacingOccurrences(of: "\n", with: "").localizedCapitalized
                            recordsDict["Day"] = headline.xpath("td")[1].content
                            recordsDict["Album"] = headline.xpath("td")[2].content
                            recordsDict["Artist"] = headline.xpath("td")[3].content
                            month = (headline.xpath("td")[0].content?.replacingOccurrences(of: "\n", with: "").localizedCapitalized)!
                            finalRecordsDictForCoreData[Constants.Years.kYear] = recordsDict
                           self.dataProvider.insertAlbum(albumToinsert: finalRecordsDictForCoreData)
                            break
                        }else{
                            print("Skipin insertin n core data simce there´s some error")
                        }
                        
                    default:
                        print("Skipping cero")
                    }
                    
                }
            }
        }
    }
    
}

