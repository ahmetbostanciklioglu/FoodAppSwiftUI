import SwiftUI

struct SectionTitleView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            Text("See All")
                .foregroundColor(.pink)
        }
    }
}
