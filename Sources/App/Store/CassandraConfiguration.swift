struct CassandraConfiguration {
    let host: String
    let port: Int32
    let username: String?
    let password: String?

    init(host: String, port: Int32, username: String? = nil, password: String? = nil) {
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }
}
