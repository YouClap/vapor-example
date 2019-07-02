import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, _ container: Container) throws {
    // Create an instance of your controller, for example an HTTP one and register it in the router

    let service = try container.make(UserService.self)
    let httpController = HTTPController(service: service)
    try router.register(collection: httpController)
}
