import Fluent
import ReactiveSwift
import Vapor

protocol CRUDStore {
    associatedtype M: Model
    associatedtype DatabaseConnection: DatabaseConnectable

    var databaseConnectable: DatabaseConnection { get }

    func create(model: M) -> SignalProducer<M, Swift.Error>
    func read(by id: M.ID) -> SignalProducer<M?, Swift.Error>
    func update(model: M) -> SignalProducer<M, Swift.Error>
    func delete(by id: M.ID) -> SignalProducer<M, Swift.Error>
}

extension CRUDStore {
    func create(model: M) -> SignalProducer<M, Swift.Error> {
        return model.save(on: databaseConnectable).reactive
    }

    func read(by id: M.ID) -> SignalProducer<M?, Swift.Error> {
        return M.find(id, on: databaseConnectable).reactive
    }

    func update(model: M) -> SignalProducer<M, Swift.Error> {
        return model.update(on: databaseConnectable).reactive
    }

    func delete(by id: M.ID) -> SignalProducer<M, Swift.Error> {
        return M.find(id, on: databaseConnectable).reactive
            .flatMap(.latest) { [databaseConnectable] model -> SignalProducer<M, Swift.Error> in
                guard let model = model else { return SignalProducer(error: CRUDStoreError.notFound) }

                return model.delete(on: databaseConnectable).reactive
                    .map { _ in model }
            }
    }
}

enum CRUDStoreError: Swift.Error {
    case notFound
}
