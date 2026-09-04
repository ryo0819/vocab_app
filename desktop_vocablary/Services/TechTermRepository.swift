//
//  TechTermRepository.swift
//  desktop_vocablary
//

import Foundation

enum TechTermRepository {
    private static let allTerms: [TechTerm] = {
        guard let url = Bundle.main.url(forResource: "TechTerms", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let terms = try? JSONDecoder().decode([TechTerm].self, from: data),
              !terms.isEmpty
        else {
            assertionFailure("TechTerms.json is missing or invalid")
            return [TechTerm(id: "fallback", term: "エラー", explanation: "データを読み込めませんでした。")]
        }
        return terms
    }()

    static func randomTerm(excluding excludedID: String? = nil) -> TechTerm {
        guard let excludedID, allTerms.count > 1 else {
            return allTerms.randomElement()!
        }
        let candidates = allTerms.filter { $0.id != excludedID }
        return candidates.randomElement() ?? allTerms.randomElement()!
    }
}
