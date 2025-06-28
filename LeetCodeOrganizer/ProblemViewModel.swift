
import Foundation
import SwiftUI

let leetCodeTopics: [String] = [
    "Arrays & Hashing", "Two Pointers", "Stack", "Binary Search", "Sliding Window",
    "Linked List", "Trees", "Tries", "Heap / Priority Queue", "Intervals", "Greedy",
    "Advanced Graphs", "1-D DP", "2-D DP", "Backtracking", "Bit Manipulation", "Math & Geometry"
]

class ProblemViewModel: ObservableObject {
    @Published var problems: [LeetCodeProblem] = []

    private let storageKey = "LeetCodeProblems"

    init() {
        loadProblems()
    }

    func toggleCompletion(for problem: LeetCodeProblem) {
        if let index = problems.firstIndex(where: { $0.id == problem.id }) {
            problems[index].isCompleted.toggle()
            saveProblems()
        }
    }

    func addProblem(_ problem: LeetCodeProblem) {
        problems.append(problem)
        saveProblems()
    }

    func updateProblem(_ updatedProblem: LeetCodeProblem) {
        if let index = problems.firstIndex(where: { $0.id == updatedProblem.id }) {
            problems[index] = updatedProblem
            saveProblems()
        }
    }

    func deleteProblem(_ problem: LeetCodeProblem) {
        problems.removeAll { $0.id == problem.id }
        saveProblems()
    }

    // MARK: - Storage
    private func saveProblems() {
        if let encoded = try? JSONEncoder().encode(problems) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadProblems() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([LeetCodeProblem].self, from: savedData) {
            self.problems = decoded
        }
    }
}
