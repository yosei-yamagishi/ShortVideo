protocol ActionSender {
    associatedtype Action

    func send(_ action: Action)
}
