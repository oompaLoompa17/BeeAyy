import UIKit
import Foundation

@Observable
final class SermonService {
	func accessSermonFolder() {
//		let calenderLink = "webcal://www.bukitarang.church/event/pre-marital-course-2025-3/?ical=1"
		if let url = URL(string: Endpoints.sermonOutline) {
			UIApplication.shared.open(url)
		}
	}
}
