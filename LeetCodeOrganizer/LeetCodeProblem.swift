import Foundation

struct LeetCodeProblem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var topic: String
    var isCompleted: Bool
}
