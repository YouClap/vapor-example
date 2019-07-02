import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ env: Environment) throws -> (Config, Services) {
    let config = Config.default()
    var services = Services.default()

    try services.register(FluentMySQLProvider())

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure MySQL
    // TODO: change later to support environments
    let mysqlDatabaseConfig = MySQLDatabaseConfig(hostname: "127.0.0.1",
                                                  port: 32768,
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

    services.register(DatabaseConnectionPoolConfig(maxConnections: 8))

    // After all the services registered, configure router
    services.register { (container) -> (UserService) in
        let mysqlDatabaseConnectable = MySQLDatabaseConnectable(container: container.subContainer(on: container))
        let store = UserStore(databaseConnectable: mysqlDatabaseConnectable)
        return UserService(store: store)
    }

    // Register routes to the router
    services.register(Router.self) { (container) -> (EngineRouter) in
        let router = EngineRouter.default()
        try routes(router, container)
        return router
    }

    return (config, services)
}
