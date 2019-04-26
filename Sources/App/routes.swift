import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Create an instance of your controller, for example an HTTP one and register it in the router

    // Perhaps initialize other dependencies to inject in the controller
    let httpController = HTTPController()
    try router.register(collection: httpController)
}
