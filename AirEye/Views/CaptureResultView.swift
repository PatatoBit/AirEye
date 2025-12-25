import SwiftUI

struct CaptureResultView: View {
  let image: UIImage
  let aqi: Int

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(height: 300)
          .cornerRadius(12)
          .padding()

        VStack(spacing: 8) {
          Text("Detected AQI: \(aqi)")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(AQIHelpers.getColor(for: aqi))

          Text(AQIHelpers.getDescription(for: aqi))
            .font(.title2)
            .fontWeight(.medium)
        }

        Divider()

        VStack(alignment: .leading, spacing: 12) {
          Text("Health Guide")
            .font(.title2)
            .bold()
            .padding(.horizontal)

          ForEach(AQIHelpers.getHealthGuide(for: aqi), id: \.self) { guide in
            HStack(alignment: .top) {
              Image(systemName: "info.circle.fill")
                .foregroundStyle(AQIHelpers.getColor(for: aqi))
              Text(guide)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)
          }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .navigationTitle("Analysis Result")
  }
}
