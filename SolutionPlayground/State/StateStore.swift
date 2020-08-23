//
//  StateStore.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/23.
//

import Foundation

protocol DiffableState: Equatable {
    func changedKeyPaths(from old: Self) -> [PartialKeyPath<Self>]
}

class StateStore<State: DiffableState> {
    
    typealias StateChangeFunc<T> = (_ state: T, _ keyPath: PartialKeyPath<T>) -> Void

    var state: State {
        didSet (old) {
            didChange(to: state, from: old)
        }
    }
    private var subscriptions: [Subscription<State>] = []

    struct Subscription<State> {
        let keyPath: PartialKeyPath<State>
        let block: StateChangeFunc<State>
    }
    
    init(_ state: State) {
        self.state = state
    }

    func onChange(_ keyPath: PartialKeyPath<State>, block: @escaping StateChangeFunc<State>) {
        subscriptions.append(Subscription<State>(keyPath: keyPath, block: block))
    }

    private func didChange(to state: State, from old: State) {
        state
            .changedKeyPaths(from: old)
            .forEach { didChange($0) }
    }

    private func didChange(_ keyPath: PartialKeyPath<State>) {
        subscriptions
            .filter { $0.keyPath == keyPath }
            .forEach { $0.block(state, keyPath) }
    }

}

var store = StateStore(AppState())
