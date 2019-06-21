import Foundation
import ReactiveSwift

final class Service: ServiceRepresentable {
    func create(user: User.Create) -> SignalProducer<User, Service.Error> {
        return SignalProducer { observer, _ in
            observer.send(value: User(id: nil, name: user.name, age: user.age, gender: user.gender))
            observer.sendCompleted() // NOTE: You have call completed to stop terminate the stream
        }
    }

    func user(with userUID: User.ID) -> SignalProducer<User, Service.Error> {
        return SignalProducer { observer, _ in
            print("🤔 searching for user with \(userUID)")

            // Simulating an Error
            // let's imagine that user doesn't exists

            observer.send(error: Error.missingUser(userUID)) // In this case, sendError already completes the stream
        }
    }

    func delete(user userUID: User.ID) -> SignalProducer<Void, Service.Error> {
        return SignalProducer { observer, _ in
            print("deleting user with UID \(userUID) 👋")

            observer.send(value: ())
            observer.sendCompleted() // NOTE: You have call completed to stop terminate the stream
        }
    }
}

extension Service {
    enum Error: Swift.Error {
        case missingUser(User.ID)
    }
}
