import SwiftUI

struct TopicDetailView: View {
    var topic: String
    @ObservedObject var viewModel: ProblemViewModel

    var body: some View {
        let topicProblems = viewModel.problems.filter { $0.topic == topic }
        let completed = topicProblems.filter { $0.isCompleted }
        let incomplete = topicProblems.filter { !$0.isCompleted }

        return ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Title centered
                    HStack {
                        Spacer()
                        Text("Completion – \(topic)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 10)

                    // Completed Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Completed")
                            .foregroundColor(.green)
                            .underline()
                            .font(.title2)
                            .padding(.bottom, 5)

                        VStack(spacing: 10) {
                            if completed.isEmpty {
                                HStack {
                                    Text("• None")
                                        .foregroundColor(.gray)
                                        .font(.body)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            } else {
                                ForEach(completed) { problem in
                                    HStack {
                                        Text("• \(problem.title)")
                                            .foregroundColor(.white)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Incomplete Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Incomplete")
                            .foregroundColor(.red)
                            .underline()
                            .font(.title2)
                            .padding(.bottom, 5)

                        VStack(spacing: 10) {
                            if incomplete.isEmpty {
                                HStack {
                                    Text("• None")
                                        .foregroundColor(.gray)
                                        .font(.body)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            } else {
                                ForEach(incomplete) { problem in
                                    HStack {
                                        Text("• \(problem.title)")
                                            .foregroundColor(.white)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
