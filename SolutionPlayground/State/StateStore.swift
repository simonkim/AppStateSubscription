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

typealias SubscriptionKey = UUID

class StateStore<State: DiffableState> {
    
    typealias StateChangeFunc<T> = (_ state: T, _ keyPath: PartialKeyPath<T>) -> Void

    var state: State {
        didSet (old) {
            didChange(to: state, from: old)
        }
    }
    
    private var callbacks: [Callback<State>] = []

    struct Callback<State> {
        let key: SubscriptionKey
        let keyPath: PartialKeyPath<State>
        let block: StateChangeFunc<State>
        
        init(_ keyPath: PartialKeyPath<State>, block: @escaping StateChangeFunc<State>) {
            self.key = UUID()
            self.keyPath = keyPath
            self.block = block
        }
    }
    
    class Subscription {
        let key: SubscriptionKey
        let unsubscribe: (_ key: SubscriptionKey) -> Void
        
        init(_ key: SubscriptionKey, unsubscribe: @escaping (_ key: SubscriptionKey) -> Void) {
            self.key = key
            self.unsubscribe = unsubscribe
        }
        
        deinit {
            unsubscribe(key)
        }
    }
    
    init(_ state: State) {
        self.state = state
    }

    let dq: DispatchQueue = .main
    
    func onChange(_ keyPath: PartialKeyPath<State>, block: @escaping StateChangeFunc<State>) -> Subscription {
        let callback = Callback<State>(keyPath, block: block)
        dq.async {
            self.callbacks.append(callback)
            print("store: callbacks: \(self.callbacks.count) new key: \(callback.key)")
        }
        return Subscription(callback.key) { [weak self] key in
            self?.unsubscribe(key)
        }
    }
    
    private func unsubscribe(_ key: SubscriptionKey) {
        print("store: unsubscribing key: \(key)")

        dq.async {
            if let index = self.callbacks.firstIndex(where: { $0.key == key }) {
                self.callbacks.remove(at: index)
                print("store: subscriptions: \(self.callbacks.count)")
            }
        }
    }

    private func didChange(to state: State, from old: State) {
        state
            .changedKeyPaths(from: old)
            .forEach { didChange($0) }
    }

    private func didChange(_ keyPath: PartialKeyPath<State>) {
        dq.async {
            self.callbacks
                .filter { $0.keyPath == keyPath }
                .forEach { $0.block(self.state, keyPath) }
        }
    }

}

var store = StateStore(AppState())
