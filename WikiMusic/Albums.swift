//
//  Albums.swift
//  WikiMusic
//
//  Created by Michel Goñi on 5/10/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import Foundation

struct Album {
    
    let albumName: String?
    let artist: String?
    let day: String?
    let isShown: Bool?
    let month: String?
    let year: String?
    let date: String?
    let dateforNotifications: String?
    
    init(albumName: String? = nil, artist: String? = nil, day: String? = nil, isShown: Bool? = nil, month: String? = nil, year: String? = nil, date: String? = nil, dateforNotifications: String? = nil) {
        
        self.albumName = albumName
        self.artist = artist
        self.day = day
        self.isShown = isShown
        self.month = month
        self.year = year
        self.date = date
        self.dateforNotifications = dateforNotifications
    }
}
