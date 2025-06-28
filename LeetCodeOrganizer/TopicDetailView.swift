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
                    //title centered and showing topic name
                    HStack {
                        Spacer()
                        Text("Completion – \(topic)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Completed")
                            .foregroundColor(.green)
                            .underline()
                            .font(.title2)
                            .padding(.bottom, 4)

                        if completed.isEmpty {
                            Text("• None")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(completed) { problem in
                                Text("• \(problem.title)")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Incomplete")
                            .foregroundColor(.red)
                            .underline()
                            .font(.title2)
                            .padding(.top, 10)
                            .padding(.bottom, 4)

                        if incomplete.isEmpty {
                            Text("• None")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(incomplete) { problem in
                                Text("• \(problem.title)")
                                    .foregroundColor(.white)
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
