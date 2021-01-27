//
//  DateExt.swift
//  Notes
//
//  Created by Daniel Caklovic on 26.01.2021..
//

import Foundation

extension Date {
    func toStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}
