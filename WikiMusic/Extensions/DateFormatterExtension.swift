//
//  DateFormatterExtension.swift
//  WikiMusic
//
//  Created by Michel Goñi on 6/10/17.
//  Copyright © 2017 Michel Goñi. All rights reserved.
//

import Foundation


extension DateFormatter {
    
    func stringMonthFormatter() -> DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "MMMM"
        
        return formatter
    }
    
    func stringYearFormatter() ->DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "yyyy"
        
        return formatter
    }
    
  
}
