import Kassandra

final class Store<RemoteStack> where RemoteStack: CassandraRemoteStack  {
    private let remoteStack: RemoteStack

    init(remoteStack: RemoteStack) {
        self.remoteStack = remoteStack
    }
}
