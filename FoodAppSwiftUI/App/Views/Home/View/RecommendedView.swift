import SwiftUI

struct RecommendedView: View {
    let dish: Dish

    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: dish.image)!,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(20)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text("Breakfast")
                    .font(.caption)
                    .foregroundColor(.teal)

                Text(dish.name)
                    .fontWeight(.medium)

                HStack(spacing: 2) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .renderingMode(.template)
                            .foregroundColor(.pink)
                    }
                    Text("\(dish.calories) Calories")
                        .font(.caption)
                        .foregroundColor(.pink)
                        .padding(.leading)
                }.padding(.bottom, 4)

                HStack {
                    Image(systemName: "clock")
                    Text("10 mins")

                    Image(systemName: "bell")
                    Text("4 Serving")
                    
                }
                .font(.caption2)
                .foregroundColor(.gray)
            }

            Spacer()

            VStack {
                Image(systemName: "heart")
                Spacer()
            }
            .frame(maxHeight: .infinity)

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
    }
}
