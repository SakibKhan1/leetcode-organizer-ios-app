import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ProblemViewModel
    @State private var selectedProblem: LeetCodeProblem?
    @State private var showingAddSheet = false
    @State private var showingEditSheet = false
    @State private var searchText = ""

    var filteredProblems: [LeetCodeProblem] {
        if searchText.isEmpty {
            return viewModel.problems
        } else {
            return viewModel.problems.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.topic.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("LeetCode Organizer")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .padding(.top, 50)

                SearchBar(searchText: $searchText)
                    .padding([.horizontal, .top])

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredProblems) { problem in
                            problemCard(for: problem)
                        }
                    }
                    .padding()
                }
            }

            addButton
        }
        .sheet(isPresented: $showingAddSheet) {
            AddProblemView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let problem = selectedProblem {
                EditProblemView(problem: problem)
            }
        }
        .onTapGesture {
            selectedProblem = nil
        }
    }

    private func problemCard(for problem: LeetCodeProblem) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                selectedProblem = (selectedProblem?.id == problem.id) ? nil : problem
            }) {
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(problem.title)
                            .foregroundColor(.white)
                            .font(.headline)
                            .lineLimit(2)
                        Text(problem.topic)
                            .foregroundColor(.orange)
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedProblem?.id == problem.id ? Color.orange.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(12)

                    if problem.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 18))
                            .padding(8)
                    }
                }
            }

            if selectedProblem?.id == problem.id {
                actionButtons(for: problem)
            }
        }
    }


    private func actionButtons(for problem: LeetCodeProblem) -> some View {
        HStack(spacing: 12) {
            ForEach(ActionType.allCases, id: \.self) { action in
                actionButton(for: action, problem: problem)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.25))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }

    private func actionButton(for action: ActionType, problem: LeetCodeProblem) -> some View {
        Button(action: {
            handleAction(action, for: problem)
        }) {
            VStack(spacing: 4) {
                Image(systemName: action.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(action.color)
                Text(action.label)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width: 80)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }

    private func handleAction(_ action: ActionType, for problem: LeetCodeProblem) {
        switch action {
        case .complete:
            viewModel.toggleCompletion(for: problem)
            selectedProblem = nil
        case .edit:
            selectedProblem = problem
            showingEditSheet = true
        case .delete:
            viewModel.deleteProblem(problem)
            selectedProblem = nil
        }
    }

    private var addButton: some View {
        HStack {
            Spacer()
            Button(action: {
                showingAddSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding()
        }
    }
}

enum ActionType: CaseIterable {
    case complete, edit, delete

    var iconName: String {
        switch self {
        case .complete: return "checkmark"
        case .edit: return "pencil"
        case .delete: return "trash"
        }
    }

    var label: String {
        switch self {
        case .complete: return "Complete"
        case .edit: return "View/Edit"
        case .delete: return "Delete"
        }
    }

    var color: Color {
        switch self {
        case .complete: return .green
        case .edit: return .blue
        case .delete: return .red
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search problems...", text: $searchText)
                .foregroundColor(.white)
        }
        .padding(10)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
    }
}
