//
//  LocalCoredataService.swift
//  WikiMusic
//
//  Created by Michel Goñi on 5/10/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService {
    
    let stack = CoreDataStack.sharedInstance
    
    func insertAlbum(albumToinsert: [String: [String: String]]) {
        
        let context = stack.persistentContainer.viewContext
        let album = AlbumManaged(context: context)
        album.albumName = albumToinsert[Constants.Years.kYear]!["Album"]!
        album.artist = albumToinsert[Constants.Years.kYear]!["Artist"]!
        album.month = albumToinsert[Constants.Years.kYear]!["Month"]!
        album.day = albumToinsert[Constants.Years.kYear]!["Day"]!
        album.year = Constants.Years.kYear
        album.date = "\(album.month!)/\(album.day!)/\(album.year!)"
        album.dateForNotifications = "\(album.month!)/\(album.day!)/2017"
       
        
        do {
            try context.save()
        }catch{
            print("Error updating album with \(error.localizedDescription)")
        }
    }
    
    func getAlbums(withYear: String, andMonth: String) -> [Album]? {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<AlbumManaged> = AlbumManaged.fetchRequest()
        let predicate = NSPredicate(format: "month contains[c] %@ AND year contains[c] %@", withYear, andMonth)
        request.predicate = predicate
        
        do {
            let fetcheAlbums = try context.fetch(request)
            
            var albums =  [Album]()
            for managedAlbum in fetcheAlbums {
                
                if managedAlbum.mappedAlbum().day != "?" {
                    
                    albums.append(managedAlbum.mappedAlbum())
                }
            }
            return albums
            
        }
        catch {
            print("error getting data from Core Data")
            return nil
        }
        
    }
    
    func getAlbumsByName(month: String) -> [Album]? {
    
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<AlbumManaged> = AlbumManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "month contains[c] %@", month)
        request.predicate = predicate
        
        do {
            let fetcheAlbums = try context.fetch(request)
            
            var albums =  [Album]()
            for managedAlbum in fetcheAlbums {
                
                albums.append(managedAlbum.mappedAlbum())
            }
            return albums
            
        }
        catch {
            print("error getting data from Core Data")
            return nil
        }
    }

}
