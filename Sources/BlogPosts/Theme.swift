import Publish
import Plot

// A minimal HTML factory compatible with Publish 0.8
struct BlogPostsHTMLFactory: HTMLFactory {
	func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<BlogPosts>) throws -> Plot.HTML? {
		HTML(
			.head(for: page, on: context.site),
			.body(
				.div(.class("site-container"),
					 .main(.class("content"),
						   .h1("Tags"),
						   .p("No tags yet.")
					 )
				)
			)
		)
	}

	func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<BlogPosts>) throws -> Plot.HTML? {
		HTML(
			.head(for: page, on: context.site),
			.body(
				.div(.class("site-container"),
					 .main(.class("content"),
						   .h1("Tag: \(page.tag.string)"),
						   .p("No posts for this tag yet.")
					 )
				)
			)
		)
	}
	
	typealias Site = BlogPosts

	init() { }

	// Index (homepage)
	func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
		HTML(
			.head(for: index, on: context.site),
			.body(
				.div(.class("site-container"),
					 .header(
						.h1(.text(context.site.name)),
						.p(.class("site-description"), .text(context.site.description))
					 ),
					 .main(.class("content"),
//						   .h2(.class("recent-posts-title"), .text("Recent Posts")),
						   .div(.class("post-list"),
								.forEach(context.allItems(sortedBy: \.date, order: .ascending)) { item in
										.article(.class("post-preview"),
												 .h3(.a(.href(item.path.absoluteString), .text(item.title))),
												 .p(.class("post-date"), .text(item.date.formatted(date: .long, time: .omitted))),
												 .if(item.description != "",
													 .p(.class("post-description"), .text(item.description))
												 )
										)
								}
						   )
					 )
				)
			)
		)
	}

	// Section page
	func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
		HTML(
			.head(for: section, on: context.site),
			.body(
				.div(.class("site-container"),
					 .header(.h1(.text(section.title))),
					 .main(.class("content"),
						   .ul(.forEach(section.items) { (item: Item<Site>) in
								   .li(.a(.href(item.path.absoluteString), .text(item.title)))
						   })
					 )
				)
			)
		)
	}

	// Item (a post)
	func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
		// Get all posts sorted by date
		let allPosts = context.allItems(sortedBy: \.date, order: .descending)

		// Find current post index
		let currentIndex = allPosts.firstIndex(where: { $0.path == item.path })

		// Get previous and next posts
		var newerPost: Item<Site>? = nil
		var olderPost: Item<Site>? = nil

		if let index = currentIndex {
			if index > 0 {
				newerPost = allPosts[index - 1]
			}
			if index < allPosts.count - 1 {
				olderPost = allPosts[index + 1]
			}
		}

		return HTML(
			.head(for: item, on: context.site),
			.body(
				.div(.class("site-container"),
					 .header(
						.a(.class("home-link"), .href("/"), .text("← Home")),
						.h1(.text(item.title))
					 ),
					 .main(.class("content"),
						   // Post content
						   .div(.class("post-body"),
								.raw(item.body.render())
						   ),
						   // Post metadata
						   .p(.class("post-meta"),
							  .text("Published: \(item.date.formatted())")
						   ),
						   // Next/Previous navigation
						   .if(olderPost != nil || newerPost != nil,
							   .nav(.class("post-navigation"),
									.div(.class("nav-links"),
										 .unwrap(olderPost) { older in
												 .div(.class("nav-previous"),
													  .a(.href(older.path.absoluteString),
														 .text("← "),
														 .text(older.title))
												 )
										 },
										 .unwrap(newerPost) { newer in
												 .div(.class("nav-next"),
													  .a(.href(newer.path.absoluteString),
														 .text(newer.title),
														 .text(" →"))
												 )
										 }
									)
							   )
						   )
						  ),
					 .footer(.p(
						.a(.class("home-link"), .href("/"), .text("← Home")),
						.text(" | Tags: "),
								.forEach(item.tags.enumerated()) { index, tag in
										.group(
											.if(index > 0, .text(", ")),
											.a(.href(context.site.path(for: tag).absoluteString),
											   .text(tag.string))
										)
								}
					 ))
				)
			)
		)
	}


	// Generic page
	func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
		HTML(
			.head(for: page, on: context.site),
			.body(
				.div(.class("site-container"),
					 .main(.class("content"), .raw(page.body.render()))
				)
			)
		)
	}


	// Tags listing
	func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML {
		HTML(
			.head(for: page, on: context.site),
			.body(
				.div(.class("site-container"),
					 .main(.class("content"),
						   .h1("Tags"),
						   .ul(.forEach(page.tags) { tag in
								   .li(.a(.href(context.site.path(for: tag).absoluteString), .text(tag.string)))
						   })
					 )
				)
			)
		)
	}

	// Top-level site HTML (can reuse index)
	func makeSiteHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
		try makeIndexHTML(for: index, context: context)
	}
}

// Theme registration that tells Publish to copy our CSS resource.
extension Theme where Site == BlogPosts {
	static var xcodeDark: Theme {
		Theme(
			htmlFactory: BlogPostsHTMLFactory(),
			resourcePaths: ["Theme/styles.css"]
		)
	}
}
