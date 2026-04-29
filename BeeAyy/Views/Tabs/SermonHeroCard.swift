import SwiftUI

struct SermonHeroCard: View {
	let sermon: Sermon
	
	var body: some View {
//		NavigationLink(destination: SermonDetailView(sermon: sermon)) {
			VStack(alignment: .leading, spacing: 12) {
				Text("This Sunday")
					.font(.caption.weight(.semibold))
					.foregroundStyle(.secondary)
					.textCase(.uppercase)
				
				Text(sermon.title)
					.font(.title3.bold())
					.multilineTextAlignment(.leading)
				
				Text(sermon.passage)
					.font(.subheadline)
					.foregroundStyle(.secondary)
				
				HStack {
					Image(systemName: "doc.text")
					Text("Open outline")
						.fontWeight(.medium)
					Spacer()
					Image(systemName: "chevron.right")
						.foregroundStyle(.tertiary)
				}
				.font(.subheadline)
				.padding(.top, 4)
			}
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
		}
//		.buttonStyle(.plain)
//	}
}
