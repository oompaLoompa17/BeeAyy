import Foundation

struct CalendarEvent: Identifiable {
	let id = UUID()
	let title: String
	let startDate: Date
	let endDate: Date?
	let description: String?
	let location: String?
}

class ICSParser {
	static func fetch(from webcalURL: String) async throws -> [CalendarEvent] {
		let httpsURL = webcalURL.replacingOccurrences(of: "webcal://", with: "https://")
		guard let url = URL(string: httpsURL) else { throw URLError(.badURL)}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		let icsString = String(data: data, encoding: .utf8) ?? ""
		return parse(icsString)
	}
	
	static func parse(_ ics: String) -> [CalendarEvent] {
		var events: [CalendarEvent] = []
		let lines = ics.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
		
		var title = "", start = "", end = "", desc = "", location = ""
		var inEvent = false
		
		for line in lines {
			if line == "BEGIN:VEVENT" { inEvent = true }
			else if line == "END:VEVENT" {
				if let startDate = parseDate(start), let endDate = parseDate(end) {
					events.append(CalendarEvent(title: title, startDate: startDate, endDate: endDate,
																			description: desc.isEmpty ? nil : desc,
																			location: location.isEmpty ? nil : location))
				}
				title = ""; start = ""; end = ""; desc = ""; location = ""
				inEvent = false
			}
			else if inEvent {
				if line.hasPrefix("SUMMARY:") { title = String(line.dropFirst(8).replacingOccurrences(of: "\\", with: "")) }
				else if line.hasPrefix("DTSTART") { start = line.components(separatedBy: ":").last ?? "" }
				else if line.hasPrefix("DTEND") { end = line.components(separatedBy: ":").last ?? "" }
				else if line.hasPrefix("DESCRIPTION:") { desc = String(line.dropFirst(12))}
				else if line.hasPrefix("LOCATION:") { location = String(line.dropFirst(9)) }
			}
		}
		for event in events {
			print(event)
		}
		return events.sorted { $0.startDate < $1.startDate }
	}
	
	static func parseDate(_ raw: String) -> Date? {
		let formatter = DateFormatter()
		let clean = raw.replacingOccurrences(of: "Z", with: "")
		formatter.dateFormat = clean.count == 8 ? "yyyyMMdd" : "yyyyMMdd'T'HHmmss"
		formatter.timeZone = TimeZone(identifier: "Asia/Singapore")
		return formatter.date(from: clean)
	}
}
