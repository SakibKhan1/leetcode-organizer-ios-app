import SwiftUI
import PhotosUI

struct EditProblemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProblemViewModel
    var problem: LeetCodeProblem

    @State private var solutions: [SolutionEntry]
    @State private var solutionImages: [UUID: UIImage] = [:]
    @State private var showingImagePicker = false
    @State private var selectedSolutionIndex: Int? = nil

    let complexityOptions = ["O(1)", "O(log n)", "O(n)", "O(n log n)", "O(n^2)", "O(2^n)", "O(n!)"]

    init(viewModel: ProblemViewModel, problem: LeetCodeProblem) {
        self.viewModel = viewModel
        self.problem = problem
        _solutions = State(initialValue: problem.solutions.isEmpty ? [SolutionEntry()] : problem.solutions)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(solutions.indices, id: \.self) { index in
                        SolutionCardView(
                            solution: $solutions[index],
                            image: solutionImages[solutions[index].id],
                            index: index,
                            onUploadTapped: {
                                selectedSolutionIndex = index
                                showingImagePicker = true
                            },
                            onRemoveTapped: {
                                let removed = solutions.remove(at: index)
                                solutionImages[removed.id] = nil
                            },
                            complexityOptions: complexityOptions
                        )
                    }

                    if solutions.count < 5 {
                        Button(action: {
                            let new = SolutionEntry()
                            solutions.append(new)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var updated = problem
                        updated.solutions = solutions
                        viewModel.updateProblem(updated)
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
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker { image in
                    if let image = image, let index = selectedSolutionIndex {
                        let id = solutions[index].id
                        solutionImages[id] = image
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Models

struct SolutionEntry: Identifiable, Codable {
    var id = UUID()
    var notes: String = ""
    var timeComplexity: String = "O(1)"
    var spaceComplexity: String = "O(1)"
}

// MARK: - ImagePicker

struct ImagePicker: UIViewControllerRepresentable {
    var onImagePicked: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var onImagePicked: (UIImage?) -> Void

        init(onImagePicked: @escaping (UIImage?) -> Void) {
            self.onImagePicked = onImagePicked
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                onImagePicked(nil)
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.onImagePicked(image as? UIImage)
                }
            }
        }
    }
}
