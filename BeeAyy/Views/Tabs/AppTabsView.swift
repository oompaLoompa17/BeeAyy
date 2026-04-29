import SwiftUI

struct AppTabsView: View {
	
	var body: some View {
		TabView {
			Tab("This Week", systemImage: "pointer.arrow.ipad") {
				ThisWeekView()
			}
			
			Tab("Library", systemImage: "folder.fill") {
				LibraryView()
			}
			
			Tab("Calendar", systemImage: "calendar") {
				CalendarView()
			}
		}
	}
}
