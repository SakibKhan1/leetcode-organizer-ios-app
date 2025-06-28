import SwiftUI

struct TopicProgressView: View {
    @ObservedObject var viewModel: ProblemViewModel

    let leetCodeTopics = [
        "Arrays & Hashing", "Two Pointers", "Sliding Window", "Stack", "Binary Search",
        "Linked List", "Trees", "Tries", "Heap / Priority Queue", "Backtracking",
        "Graphs", "Advanced Graphs", "1D DP", "2D DP", "Greedy",
        "Intervals", "Math & Geometry", "Bit Manipulation"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Spacer()
                            Text("DSA Topics")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 10)

                        ForEach(leetCodeTopics, id: \.self) { topic in
                            NavigationLink(destination: TopicDetailView(topic: topic, viewModel: viewModel)) {
                                topicProgressView(for: topic)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    func topicProgressView(for topic: String) -> some View {
        let topicProblems = viewModel.problems.filter { $0.topic == topic }
        let total = topicProblems.count
        let completed = topicProblems.filter { $0.isCompleted }.count
        let progress = total > 0 ? Float(completed) / Float(total) : 0

        return VStack(alignment: .leading, spacing: 8) {
            Text(topic)
                .foregroundColor(.white)
                .font(.headline)

            ProgressView(value: progress)
                .accentColor(.orange)
                .frame(height: 8)

            Text("\(completed) out of \(total) completed")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}
