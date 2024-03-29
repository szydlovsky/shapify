//
//  DateFormatterExtensions.swift
//  Shapify

import Foundation

extension DateFormatter {
    static let appFormatter = DateFormatter().then {
        $0.dateFormat = "d MMM yyyy, HH:mm"
        $0.locale = Locale(identifier: "en_us")
    }
}
