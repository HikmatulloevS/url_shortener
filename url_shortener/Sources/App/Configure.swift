import Fluent
import FluentPostgresDriver
import Vapor


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                port: 5433,
                username: "postgres",
                password: "",
                database: "postgres",
                tls: .disable
            )
        ),
        as: .psql
    )

    app.migrations.add(URLMigration())
    app.migrations.add(Analyticsigration())
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
