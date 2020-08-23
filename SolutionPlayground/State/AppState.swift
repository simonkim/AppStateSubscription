//
//  AppState.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/23.
//

import Foundation


struct AppState {
    var count: Int = 0
    var second: Int = 0
    var isNetworkReachable: Bool = false
}

protocol AppStateReadable {
    func onChangeCount(block: @escaping (_ value: Int) -> Void) -> Subscription
    func onChangeSecond(block: @escaping (_ value: Int) -> Void) -> Subscription
}

enum UpdateAction {
    case countUp
    case countDown
    case second(Int)
}

protocol AppStateUpdatable {
    mutating func send(_ change: UpdateAction)
}

extension AppState {
    private static var store = StateStore(AppState())

    static func reader() -> AppStateReadable {
        return store
    }
    
    static func updater() -> AppStateUpdatable {
        return store
    }
}

// MARK: - Implementation
extension AppState: DiffableState {
    func changedKeyPaths(from old: Self) -> [PartialKeyPath<Self>] {
        guard self != old else { return [] }

        var result: [PartialKeyPath<Self>] = []
        result += intKeyPaths.filter { self[keyPath: $0] != old[keyPath: $0] }
        result += boolKeyPaths.filter { self[keyPath: $0] != old[keyPath: $0] }
        return result
    }

    var intKeyPaths: [KeyPath<Self, Int>] { [\.count, \.second] }
    var boolKeyPaths: [KeyPath<Self, Bool>] { [\.isNetworkReachable] }

}

extension StateStore: AppStateReadable where State == AppState {
    func onChangeCount(block: @escaping (_ value: Int) -> Void) -> Subscription {
        return onChange(\AppState.count, block: block)
    }
    
    func onChangeSecond(block: @escaping (_ value: Int) -> Void) -> Subscription {
        return onChange(\AppState.second, block: block)
    }
    
    private func onChange<T>(_ keyPath: KeyPath<AppState, Int>, block: @escaping (_ value: T) -> Void ) -> Subscription {
        return onChange(keyPath) { state, keyPath in
            guard let count = state[keyPath: keyPath] as? T else { return }
            block(count)
        }
    }
}

extension StateStore: AppStateUpdatable where State == AppState {
    func send(_ change: UpdateAction) {
        var state = self.state
        switch change {
        case .countUp:
            state.count += 1
        case .countDown:
            state.count -= 1
            
        case .second(let value):
            state.second = value
        }
        self.state = state
    }
    
}
