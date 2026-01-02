import SwiftUI

struct GalleryResult: Identifiable, Hashable {
  let id = UUID()
  let image: UIImage
  let aqi: Int
}

struct GalleryResultsView: View {
  let results: [GalleryResult]

  var body: some View {
    TabView {
      ForEach(results) { result in
        CaptureResultView(image: result.image, aqi: result.aqi)
      }
    }
    .tabViewStyle(.page)
    .indexViewStyle(.page(backgroundDisplayMode: .always))
    .navigationTitle("Gallery Analysis")
    .navigationBarTitleDisplayMode(.inline)
  }
}
