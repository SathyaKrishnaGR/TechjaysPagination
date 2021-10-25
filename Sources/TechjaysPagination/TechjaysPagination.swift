public struct TechjaysPagination {
    var paginatedTableView: PaginatedTableView!
    public static let shared = TechjaysPagination()
    public func setupPagination(baseUrl: String, version: String, defaultOffset: String) {
        URLFactory.shared.baseUrl = baseUrl
        URLFactory.shared.version = version
//        PaginationManager().shared.limit = defaultOffset
    }
}


