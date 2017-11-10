//
//  AlbumsManaged+Mapped.swift
//  WikiMusic
//
//  Created by Michel Goñi on 5/10/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import Foundation

extension AlbumManaged {
    
    func mappedAlbum() -> Album {
        
        return Album(albumName: self.albumName,
                     artist: self.artist,
                     day: self.day,
                     isShown: self.isShown,
                     month: self.month,
                     year: self.year,
                     date: self.date,
                     dateforNotifications: self.dateForNotifications)
    }
}
