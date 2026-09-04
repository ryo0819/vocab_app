//
//  TechTerm.swift
//  desktop_vocablary
//

import Foundation

struct TechTerm: Codable, Identifiable {
    let id: String
    let term: String
    let explanation: String
}
