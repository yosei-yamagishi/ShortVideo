protocol StateHolder: AnyObject {
    associatedtype State

    var state: State { get }
}
