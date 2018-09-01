//
//  DateFormatterExtension.swift
//  Gente3
//
//  Created by Song, InKyung on 9/1/18.
//  Copyright © 2018 IKSong. All rights reserved.
//

import Foundation

//This will ensure that we create one date formatter for one date format only once
extension DateFormatter {
    static let isoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
}
