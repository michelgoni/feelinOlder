//
//  Array+Extension.swift
//  WikiMusic
//
//  Created by Miguel Goñi on 20/10/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

