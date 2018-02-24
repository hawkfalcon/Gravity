protocol Configurable {
    
    associatedtype Model
    var model: Model? { get set }
    func configureWithModel(_: Model)
    
}
