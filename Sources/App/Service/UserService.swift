import ReactiveSwift
import Vapor

//final class UserService<Store>: UserServiceRepresentable where Store: UserStoreRepresentable {
// TODO: Change this to work with store representation instead of UserStore class
// Use class for now to avoid to have type erasure
final class UserService: UserServiceRepresentable {
    private let store: UserStore

    init(store: UserStore) {
        self.store = store
    }

    func create(user: User.Create) -> SignalProducer<User, UserService.Error> {
        return store.create(model: User(id: nil, name: user.name, age: user.age, gender: user.gender))
            .mapError(UserService.Error.store)
    }

    func user(with userUID: User.ID) -> SignalProducer<User, UserService.Error> {
        return store.read(by: userUID)
            .mapError(Error.store)
            .flatMap(.latest) { user -> SignalProducer<User, UserService.Error> in
                guard let user = user else {
                    return SignalProducer(error: Error.missingUser(userUID))
                }

                return SignalProducer(value: user)
            }
    }

    func delete(user userUID: User.ID) -> SignalProducer<User, UserService.Error> {
        return store.delete(by: userUID)
            .mapError(Error.store)
    }
}

extension UserService {
    enum Error: Swift.Error {
        case missingUser(User.ID)
        case store(Swift.Error)
    }
}
