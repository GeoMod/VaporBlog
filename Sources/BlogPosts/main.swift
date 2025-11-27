import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct BlogPosts: Website {
	enum SectionID: String, WebsiteSectionID {
		// Add the sections that you want your website to contain here:
		case posts
	}
	
	struct ItemMetadata: WebsiteItemMetadata {
		// Add any site-specific metadata that you want to use here.
	}
	
	// Update these properties to configure your website:
	var url = URL(string: "https://geomod.github.io/VaporBlog/")!
	var name = "Certainly Swift on the Server"
	var description = "How to get started and continue learning Vapor, Fluent, and anything else for Server Side Swift."
	var language: Language { .english }
	var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
//try BlogPosts().publish(
//	withTheme: .xcodeDark,
//	plugins: [.splash(withClassPrefix: "")]
//)

try BlogPosts().publish(
	withTheme: .xcodeDark,
	deployedUsing: .gitHub(
		"geomod/VaporBlog",   // GitHub repo in "username/repo" format
		branch: "GHpublish",  // branch you want to deploy
		useSSH: true          // use SSH for pushing
	), plugins: [.splash(withClassPrefix: "")]
)
