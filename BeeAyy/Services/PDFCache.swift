import Foundation

// MARK: an actor that handles the actual disk operations. Actors serialize access, which prevents the "two views try to write the same file at once" race. For a personal app you'll probably never hit this, but it costs nothing and removes a class of bugs
actor PDFCache {
	enum Location {
		case temporary  // .cachesDirectory — eviction allowed
		case permanent  // .documentsDirectory — user-saved
	}
	
	func url(for sermonID: String, location: Location) -> URL {
		let dir: FileManager.SearchPathDirectory =
		location == .temporary ? .cachesDirectory : .documentDirectory
		return FileManager.default
			.urls(for: dir, in: .userDomainMask)[0]
			.appendingPathComponent("sermon-\(sermonID).pdf")
	}
	
	func load(sermonID: String, location: Location) -> Data? {
		try? Data(contentsOf: url(for: sermonID, location: location))
	}
	
	func save(_ data: Data, sermonID: String, location: Location) throws {
		try data.write(to: url(for: sermonID, location: location))
	}
	
	func promoteToPermanent(sermonID: String) throws {
		let from = url(for: sermonID, location: .temporary)
		let to = url(for: sermonID, location: .permanent)
		try? FileManager.default.removeItem(at: to)  // overwrite if exists
		try FileManager.default.copyItem(at: from, to: to)
	}
	
	func exists(sermonID: String, location: Location) -> Bool {
		FileManager.default.fileExists(atPath: url(for: sermonID, location: location).path)
	}
}
