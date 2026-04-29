import SwiftUI

struct ChurchCalendarView: View {
	@State private var events: [CalendarEvent] = []
	@State private var isLoading = false
	
	// Add all your church webcal URLs here
	let feeds = [
		("Weekly Prayer", Endpoints.prayerMeetings),
		("Cell Group", Endpoints.friGGCalendar),
	]
	
	var body: some View {
		NavigationStack {
			List(events) { event in
				VStack(alignment: .leading, spacing: 4) {
					Text(event.title).font(.headline)
					Text(event.startDate.formatted(date: .abbreviated, time: .shortened))
						.font(.subheadline).foregroundStyle(.secondary)
				}
				.padding(.vertical, 4)
			}
			.navigationTitle("Church Calendar")
			.overlay { if isLoading { ProgressView() } }
			.task { await loadAll() }
		}
	}
	
	func loadAll() async {
		isLoading = true
		var all: [CalendarEvent] = []
		for (_, url) in feeds {
			let fetched = (try? await ICSParser.fetch(from: url)) ?? []
			all.append(contentsOf: fetched)
		}
		events = all.sorted { $0.startDate < $1.startDate }
		isLoading = false
	}
}
