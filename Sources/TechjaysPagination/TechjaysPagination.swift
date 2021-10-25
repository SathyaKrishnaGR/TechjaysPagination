public struct TechjaysPagination {
    var paginatedTableView: PaginatedTableView!
    public static let shared = TechjaysPagination()
    public func setupPagination(baseUrl: String, version: String, token: String) {
        URLFactory.shared.baseUrl = baseUrl
        URLFactory.shared.version = version
    }
}


