import SwiftUI

struct AddProblemView: View {
    @ObservedObject var viewModel: ProblemViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var selectedTopic: String = "Arrays & Hashing"

    let leetCodeTopics = [
        "Arrays & Hashing", "Two Pointers", "Sliding Window", "Stack", "Binary Search",
        "Linked List", "Trees", "Tries", "Heap / Priority Queue", "Backtracking",
        "Graphs", "Advanced Graphs", "1D DP", "2D DP", "Greedy",
        "Intervals", "Math & Geometry", "Bit Manipulation"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Add New Problem")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

                        // Problem Name
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Problem Name")
                                .foregroundColor(.white)
                                .font(.headline)

                            TextField("e.g. Two Sum", text: $title)
                                .padding()
                                .background(Color(white: 0.85))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Topic")
                                .foregroundColor(.white)
                                .font(.headline)

                            Picker("", selection: $selectedTopic) {
                                ForEach(leetCodeTopics, id: \.self) { topic in
                                    Text(topic)
                                        .foregroundColor(.black)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .labelsHidden()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                        }

                        Button(action: {
                            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            let newProblem = LeetCodeProblem(title: title, topic: selectedTopic, isCompleted: false)
                            viewModel.addProblem(newProblem)
                            dismiss()
                        }) {
                            Text("Add Problem")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .padding(.top, 80)
                }

                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
