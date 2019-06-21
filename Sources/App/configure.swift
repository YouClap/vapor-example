import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(FluentMySQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure MySQL
    // TODO: change later to support environments
    let mysqlDatabaseConfig = MySQLDatabaseConfig(hostname: "127.0.0.1",
                                                  port: 32773,
                                                  username: "root",
                                                  password: "youclap-sql-pw",
                                                  database: "youclap-dev",
                                                  characterSet: .utf8mb4_unicode_ci)

    var databaseConfig = DatabasesConfig()
    databaseConfig.enableLogging(on: .mysql)
    databaseConfig.add(database: MySQLDatabase(config: mysqlDatabaseConfig), as: .mysql)
    services.register(databaseConfig)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)
}
