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
    private let streakKey = "streakCount"
    private let lastActiveKey = "lastActiveDate"

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
        var newProblem = problem
        newProblem.dateAdded = Date()
        problems.append(newProblem)
        saveProblems()
        updateStreakIfNeeded()
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

    func saveProblems() {
        if let encoded = try? JSONEncoder().encode(problems) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    func loadProblems() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([LeetCodeProblem].self, from: savedData) {
            self.problems = decoded
        }
    }

    // Returns the current streak from UserDefaults
    func calculateStreak() -> Int {
        return UserDefaults.standard.integer(forKey: streakKey)
    }

    // Updates the streak if a new problem is added today
    private func updateStreakIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let lastActive = UserDefaults.standard.object(forKey: lastActiveKey) as? Date
        var streak = UserDefaults.standard.integer(forKey: streakKey)

        if let lastDate = lastActive {
            if calendar.isDate(lastDate, inSameDayAs: today) {
                return
            } else if calendar.isDate(lastDate, inSameDayAs: yesterday) {
                streak += 1
            } else {
                streak = 1
            }
        } else {
            streak = 1
        }

        UserDefaults.standard.set(today, forKey: lastActiveKey)
        UserDefaults.standard.set(streak, forKey: streakKey)
    }
}
