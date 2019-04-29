import Kassandra
import Vapor

protocol DatabaseRemoteStack {
    associatedtype DatabaseQuery

    typealias DatabaseResource = Resource & QueryResource & ExternalResource

    func fetch<R: DatabaseResource>(resource: R, completion: @escaping (Swift.Result<R.External, Error>) -> Void)
    where R.Query == DatabaseQuery
}

final class CassandraRemoteStack: DatabaseRemoteStack {
    typealias DatabaseQuery = Kassandra.Query
    typealias Cenas = Vapor.Content

    private let cassandra: Kassandra

    init(cassandraConfiguration: CassandraConfiguration) {
        cassandra = Kassandra(host: cassandraConfiguration.host,
                              port: cassandraConfiguration.port,
                              using: cassandraConfiguration.authentication)
        cassandra.delegate = self
    }

    func fetch<R>(resource: R, completion: @escaping (Swift.Result<R.External, Error>) -> Void)
    where R : DatabaseResource, DatabaseQuery == R.Query {

    }
}

extension CassandraConfiguration {
    var authentication: (String, String)? {
        guard let username = username, let password = password else { return nil }

        return (username, password)
    }
}

extension CassandraRemoteStack: KassandraDelegate {
    func didReceiveEvent(event: Event) {
        print("received cassandra event \(event)")
    }
}
