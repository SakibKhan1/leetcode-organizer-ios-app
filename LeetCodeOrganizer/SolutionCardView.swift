
import SwiftUI

struct SolutionCardView: View {
    @Binding var solution: SolutionEntry
    var image: UIImage?
    var index: Int
    var onUploadTapped: () -> Void
    var onRemoveTapped: () -> Void
    let complexityOptions: [String]

    @State private var showImageOptions = false
    @State private var showFullImage = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Solution \(index + 1)")
                .font(.headline)
                .foregroundColor(.white)

            Button(action: {
                if image != nil {
                    showImageOptions = true
                } else {
                    onUploadTapped()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 180)

                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("Upload Screenshot")
                            .foregroundColor(.white)
                    }
                }
            }
            .confirmationDialog("Options", isPresented: $showImageOptions, titleVisibility: .visible) {
                Button("View") { showFullImage = true }
                Button("Replace") { onUploadTapped() }
                Button("Cancel", role: .cancel) {}
            }
            .fullScreenCover(isPresented: $showFullImage) {
                if let img = image {
                    ZStack(alignment: .topTrailing) {
                        Color.black.ignoresSafeArea()

                        ZoomableScrollView {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                        }

                        Button(action: { showFullImage = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            ZStack(alignment: .topLeading) {
                if solution.notes.isEmpty {
                    Text("Write text notes here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                }

                TextEditor(text: $solution.notes)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .frame(height: 140)
                    .cornerRadius(10)
                    .padding(4)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Time Complexity").foregroundColor(.white)
                Picker("Time Complexity", selection: $solution.timeComplexity) {
                    ForEach(complexityOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

                Text("Space Complexity").foregroundColor(.white)
                Picker("Space Complexity", selection: $solution.spaceComplexity) {
                    ForEach(complexityOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }

            if index > 0 {
                Button(action: onRemoveTapped) {
                    Text("Remove Solution")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
    }
}


struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = context.coordinator

        let hostedView = UIHostingController(rootView: content).view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)

        scrollView.addSubview(hostedView)
        context.coordinator.hostedView = hostedView
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostedView: UIView?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostedView
        }
    }
}
