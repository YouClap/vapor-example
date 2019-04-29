import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let cassandraConfiguration = CassandraConfiguration(host: "localhost", port: 32772)
    let remoteStack = CassandraRemoteStack(cassandraConfiguration: cassandraConfiguration)
    let store = Store(remoteStack: remoteStack)
    services.register(store)
}

extension Store: Vapor.Service {}
