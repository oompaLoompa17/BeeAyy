import Foundation

struct ThisWeekData {
	let currentSermon: Sermon?       // nil if not yet published
	let currentBulletin: Bulletin?
	let weeklyVerse: Verse?
	let upcomingEvents: [CalendarEvent]  // next 7 days, max ~5
}

struct Sermon: Codable {
	let id: String // yyy-MM-dd
	let title: String
	let passage: String      // e.g. "Romans 8:1-11"
	let speaker: String
	let date: Date
	let pdfURL: URL
	let wordURL: URL
}

struct Bulletin: Codable {
	let date: Date
	let pdfURL: URL
}

struct Verse: Codable {
	let reference: String     // "Romans 8:1"
	let text: String
}

struct WeeklyManifest: Codable {
	let sermon: Sermon
	let bulletin: Bulletin
	let verse: Verse
}

//{
//	"sermon": {
//		"id": "2026-04-26",
//		"date": "2026-04-26",
//		"title": "Walking by the Spirit",
//		"passage": "Romans 8:1-11",
//		"speaker": "Pastor John",
//		"pdfURL": "https://drive.google.com/uc?export=download&id=1Qi1OJ__e27rmwmKFyvtxedxUG2lMB5Qm",
//		"wordURL": "https://drive.google.com/uc?export=download&id=1W0R9HgjHC9hEQJBmKGRE5U9Kpup-ULJv"
//	},
//	"bulletin": {
//		"date": "2026-04-26",
//		"pdfURL": "https://drive.google.com/uc?export=download&id=1lILqOaATBJFEZHRj3gPvqRAZfwX2CJwp"
//	},
//	"verse": {
//		"reference": "Romans 8:1",
//		"text": "There is therefore now no condemnation..."
//	}
//}


