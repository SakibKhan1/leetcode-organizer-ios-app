import SwiftUI

struct AddProblemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProblemViewModel

    @State private var title = ""
    @State private var selectedTopic = "Arrays & Hashing"

    let leetCodeTopics = [
        "Arrays & Hashing", "Two Pointers", "Sliding Window", "Stack", "Binary Search",
        "Linked List", "Trees", "Tries", "Heap / Priority Queue", "Backtracking",
        "Graphs", "Advanced Graphs", "1D DP", "2D DP", "Greedy",
        "Intervals", "Math & Geometry", "Bit Manipulation"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add New Problem")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            TextField("Title", text: $title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)

            Text("Topic")
                .foregroundColor(.white)

            Picker("Topic", selection: $selectedTopic) {
                ForEach(leetCodeTopics, id: \.self) { topic in
                    Text(topic)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Spacer()

            Button(action: {
                let newProblem = LeetCodeProblem(title: title, topic: selectedTopic, isCompleted: false)
                viewModel.problems.append(newProblem)
                dismiss()
            }) {
                Text("Add Problem")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.black)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
