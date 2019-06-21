import Vapor
import ReactiveSwift

final class HTTPController: RouterController {

    private let service: ServiceRepresentable

    init(service: ServiceRepresentable) {
        self.service = service
    }

    func boot(router: Router) throws {
        let users = router.grouped("user")

        users.get("/", User.ID.parameter, use: index)
        users.post(User.Create.self, at: "/", use: create)
        users.delete("/", User.ID.parameter, use: delete)
    }

    // MARK: - CRUD Methods

    // NOTE: We can return a SignalProducer, but perhaps we could return a Future
    // to have a uniform API
    private func index(_ request: Request) throws -> Future<User> {
        let uid = try userID(from: request)

        return User.find(uid, on: request).map {
            guard let user = $0 else { throw Abort(.notFound) }
            return user
        }

//        return service.user(with: uid)
//            .mapError(Error.service)
    }

    private func create(_ request: Request, user: User.Create) throws -> Future<Response> {
        let user = User(id: nil, name: user.name, age: user.age, gender: user.gender)

        return user.save(on: request).encode(status: .created, for: request)
//        return service.create(user: user)
//            .mapError(Error.service)
//            .encode(status: .created, for: request)
    }

    private func delete(_ request: Request) throws -> Future<HTTPStatus> {
        let uid = try userID(from: request)

        return User.find(uid, on: request).flatMap { user -> Future<Void> in
            guard let user = user else { throw Abort(.notFound) }

            return user.delete(on: request)
        }.transform(to: .ok)

//        return try service.delete(user: uid)
//            .map { _ in HTTPStatus.ok }
//            .mapError(Error.service)
//            .encode(for: request)
    }

    // MARK: - Private Methods

    private func userID(from request: Request) throws -> User.ID {
        guard let userID = try? request.parameters.next(User.ID.self) else {
            throw Abort(.notFound)
        }

        return userID
    }
}

extension HTTPController {
    enum Error: Swift.Error {
        case service(Service.Error)
    }
}

// MARK: - Debuggable

extension Service.Error: Debuggable {
    var identifier: String {
        switch self {
        case .missingUser: return "MISSING_USER"
        }
    }

    var reason: String {
        switch self {
        case .missingUser(let userID):
            return "user \(userID) not found"
        }
    }
}

extension HTTPController.Error: Debuggable {
    var identifier: String {
        switch self {
        case .service(let serviceError): return serviceError.identifier
        }
    }

    var reason: String {
        switch self {
        case .service(let serviceError): return serviceError.reason
        }
    }
}
