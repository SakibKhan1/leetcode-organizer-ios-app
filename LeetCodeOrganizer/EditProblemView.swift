import SwiftUI

struct EditProblemView: View {
    @Environment(\.dismiss) var dismiss
    var problem: LeetCodeProblem

    @State private var solutions: [SolutionEntry] = [SolutionEntry()]

    let complexityOptions = ["O(1)", "O(log n)", "O(n)", "O(n log n)", "O(n^2)", "O(2^n)", "O(n!)"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(solutions.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Solution \(index + 1)")
                                .font(.headline)
                                .foregroundColor(.white)

                            Button(action: {
                                
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 180)
                                    Text("Upload Screenshot")
                                        .foregroundColor(.white)
                                }
                            }

                            ZStack(alignment: .topLeading) {
                                if solutions[index].notes.isEmpty {
                                    Text("Write text notes here...")
                                        .foregroundColor(.gray)
                                        .padding(10)
                                }
                                TextEditor(text: $solutions[index].notes)
                                    .foregroundColor(.black)
                                    .frame(height: 120)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Time Complexity")
                                    .foregroundColor(.white)
                                Picker("Time Complexity", selection: $solutions[index].timeComplexity) {
                                    ForEach(complexityOptions, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)

                                Text("Space Complexity")
                                    .foregroundColor(.white)
                                Picker("Space Complexity", selection: $solutions[index].spaceComplexity) {
                                    ForEach(complexityOptions, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }

                            if index > 0 {
                                Button(action: {
                                    solutions.remove(at: index)
                                }) {
                                    Text("Remove Solution")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                    }

                    if solutions.count < 5 {
                        Button(action: {
                            solutions.append(SolutionEntry())
                        }) {
                            Text("Add Another Solution")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Edit Problem")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SolutionEntry: Identifiable {
    var id = UUID()
    var notes: String = ""
    var timeComplexity: String = "O(1)"
    var spaceComplexity: String = "O(1)"
}
