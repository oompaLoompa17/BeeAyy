import SwiftUI

struct ThisWeekView: View {
	@State private var data: WeeklyManifest
	@State private var isLoading = false
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 16) {
					headerStrip
					
					SermonHeroCard(sermon: data.sermon)
					
//					QuickLinksFooter()
				}
				.padding(.horizontal)
				.padding(.bottom, 32)
			}
			.navigationTitle("This Week")
			.task { await load() }
			.refreshable { await load() }
		}
	}
	
	private var headerStrip: some View {
		HStack {
			VStack(alignment: .leading, spacing: 2) {
				Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
					.font(.subheadline)
					.foregroundStyle(.secondary)
				Text(greeting)
					.font(.title2.bold())
			}
			Spacer()
		}
		.padding(.top, 8)
	}
	
	private var greeting: String {
		let hour = Calendar.current.component(.hour, from: .now)
		switch hour {
		case 5..<12: return "Good morning"
		case 12..<17: return "Good afternoon"
		default: return "Good evening"
		}
	}
	
	private func load() async {
		isLoading = true
		defer { isLoading = false }
//		data = await ThisWeekService.shared.fetch()
	}
}
