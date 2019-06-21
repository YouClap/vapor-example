import ReactiveSwift

protocol ServiceRepresentable {
    func create(user: User.Create) -> SignalProducer<User, Service.Error>
    func user(with userUID: User.ID) -> SignalProducer<User, Service.Error>
    func delete(user userUID: User.ID) -> SignalProducer<Void, Service.Error>
}
