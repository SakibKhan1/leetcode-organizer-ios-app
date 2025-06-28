import Foundation
import UIKit

struct LeetCodeProblem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var topic: String
    var isCompleted: Bool
    var solutions: [SolutionEntry] = []
}

struct SolutionEntry: Identifiable, Codable {
    var id = UUID()
    var notes: String = ""
    var timeComplexity: String = "O(1)"
    var spaceComplexity: String = "O(1)"
    var imagePath: String? = nil  // Local file path to the image
}
