public struct TechjaysPagination {
    var paginatedTableView: PaginatedTableView!
    public init() {
        
    }
    
    func testThisOut(baseUrl: String, version: String, environment: String) -> PaginatedTableView {
        print("Base URL", baseUrl)
        let fayv = Urls.init(base: baseUrl, version: version, fayvEnvironment: "dev")
        print("Fayv", fayv)
        return paginatedTableView
    }
    
}
