import SwiftUI

struct SermonDetailView: View {
	@State private var viewModel: SermonDetailViewModel
	
	init(sermon: Sermon, repository: SermonRepository) {
		_viewModel = State(initialValue: SermonDetailViewModel(
			sermon: sermon, repository: repository
		))
	}
	
	var body: some View {
		Group {
			if let pdf = viewModel.pdf {
				PDFViewer(document: pdf)
			} else if viewModel.isLoading {
				ProgressView("Loading outline…")
			} else if viewModel.loadError != nil {
				ContentUnavailableView(
					"Couldn't load outline",
					systemImage: "doc.text.magnifyingglass",
					description: Text("Pull down to try again.")
				)
			} else {
				Color.clear
			}
		}
		.navigationTitle(viewModel.sermon.title)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				downloadButton
			}
		}
		.task { await viewModel.load() }
		.refreshable { await viewModel.load() }
	}
	
	private var downloadButton: some View {
		Button {
			Task { await viewModel.download() }
		} label: {
			Image(systemName: viewModel.isDownloaded
						? "checkmark.circle.fill"
						: "arrow.down.circle")
		}
		.disabled(viewModel.isDownloaded || viewModel.pdf == nil)
	}
}
