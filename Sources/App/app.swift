import Vapor

/// Creates an instance of Application. This is called from main.swift in the run target.
public func app(_ env: Environment) throws -> Application {
    // Start preparation for Vapor 4
    let (config, services) = try configure(env)
    let app = try Application(config: config,
                              environment: env,
                              services: services)
    try boot(app)
    return app
}
