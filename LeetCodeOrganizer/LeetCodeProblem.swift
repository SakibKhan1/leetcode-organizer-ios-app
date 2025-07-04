import Foundation
import UIKit

struct LeetCodeProblem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var topic: String
    var isCompleted: Bool
    var solutions: [SolutionEntry] = []
    var dateAdded: Date = Date() //added this for streak tracking to remind myself
}

struct SolutionEntry: Identifiable, Codable {
    var id = UUID()
    var notes: String = ""
    var timeComplexity: String = "O(1)"
    var spaceComplexity: String = "O(1)"
    var imagePath: String? = nil
}
