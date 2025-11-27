---
date: 2025-10-15 18:00
title: Exploring our new Vapor Project
description: Get to know your Vapor project.
tags: swift, vapor
---

# Exploring your new Vapor Project


Open your newly created project either by opening the newly created folder named SwiftlyGround and double-clicking the Package.swift file. Or if you’re still in the terminal you can navigate to the folder SwiftlyGround and type;

<b>open Package.swift</b>

Either method should launch Xcode and the project will begin loading quite a list of dependencies. These packages are all part of what makes Vapor run and it really isn’t necessary to know what they all do. I certainly don't.

**Important**: Make sure you select your Mac as the run destination for this project. Xcode might select your iPhone by default if you have been building iOS apps. You will get a build error if you try building to an iOS device.

Looking around our new project, SwiftlyGround you should see the following file structure.

Starting at the top with the Package file this is where you'll see a list of dependencies and their targets. Later on you may add a package there if you wanted to incorporate Sign in with Apple for example. Among many other things.

```swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SwiftlyGround",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftlyGround",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SwiftlyGroundTests",
            dependencies: [
                .target(name: "SwiftlyGround"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
```

The **Public** folder is empty and will likely stay that way for the duration of this project. It could be used to serve static files—such as images, CSS, JavaScript, or HTML directly to the client app without routing through your Swift code.

The **Sources** folder is where things get interesting and we will be working heavily in the folders within Sources. 

**Controllers** – Handle requests from your client and return responses. Here's an example of an endpoint we will later add to the Controllers file;

```
 @Sendable
	func create(_ req: Request) async throws -> HTTPStatus {
		let data = try req.content.decode(CoffeeShopDTO.self)

		let newCoffeeShop = CoffeeShop(
			name: data.name,
			address: data.address,
			phoneNumber: data.phoneNumber,
			seatingCapacity: data.seatingCapacity
		)

		do {
			try await newCoffeeShop.save(on: req.db)
			return .ok
		} catch {
			throw Abort(.internalServerError, reason: "Failed to save coffee shop")
		}
	}
```

**DTO** (Data Transfer Objects) – Define the shape of data sent to or from your API. For example, you might have a User model with properties for userName, city, and birthday. While your server stores all three, you may not want to include birthday in every user response. A DTO lets you define a version of the data containing only userName and city, which is safe to send to clients.

**Migrations** – Manage changes to your database schema over time, such as creating new fields defined on existing tables.

**Models** – Represent data structures stored in your database. Models map Swift classes to database tables and are used for querying, creating, and updating records.

You can think of your database as a collection of tables, where each table represents a specific type of data. In Vapor, each table corresponds to a Model, and the columns (or fields) in that table represent the model's properties. For example, our SwiftlyGround coffee shop could be represented by a SwiftlyGround model. Its properties like address, phoneNumber, and hoursOfOperation become the fields of the database table that store the details of the coffee shop.

The *configure* file is where we will add our Migrations to the API.

The *entrypoint* file in a Vapor project is where the app starts running. It initializes the application, sets up configurations (like routes, middleware, and database connections), and then launches the server.

Finally our routes file is where all of our controllers get initialized and added to the application.

That's a good overview of the project. In the next section we will start defining our first model for SwiftlyGround.

I hope you have enjoyed the reading so far. You can reach out to me on various social platforms.


[Bluesky](https://bsky.app/profile/danoleary.me)

[X](https://x.com/devdanoleary)

[Instagram](https://www.instagram.com/devdanoleary/?igsh=NXl4MWZzejBleDRo&utm_source=qr)
