import SwiftUI

struct SolutionCardView: View {
    @Binding var solution: SolutionEntry
    var image: UIImage?
    var index: Int
    var onUploadTapped: () -> Void
    var onRemoveTapped: () -> Void
    let complexityOptions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Solution \(index + 1)")
                .font(.headline)
                .foregroundColor(.white)

            Button(action: onUploadTapped) {
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

            ZStack(alignment: .topLeading) {
                if solution.notes.isEmpty {
                    Text("Write text notes here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                        .padding(10)
                }
                TextEditor(text: $solution.notes)
                    .foregroundColor(.black)
                    .frame(height: 120)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
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
