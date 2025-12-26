import Foundation
import Ignite

@main
struct IgniteWebsite {
    static func main() async {
        var site = ExampleSite()

        do {
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ExampleSite: Site {    
    var name = "Certainly Swift on the Server"
    var titleSuffix = " – A Vapor Blog by Dan O'Leary"
    var url = URL(static: "https://www.example.com")
    var builtInIconsEnabled = true

    var author = "Dan O'Leary"

    var homePage = Home()
    var layout = MainLayout()
}
