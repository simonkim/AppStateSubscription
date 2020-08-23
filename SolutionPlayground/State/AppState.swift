//
//  AppState.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/23.
//

import Foundation


struct AppState {
    var count: Int = 0
    var seconds: Int = 0
    var isNetworkReachable: Bool = false
}

extension AppState: DiffableState {
    func changedKeyPaths(from old: Self) -> [PartialKeyPath<Self>] {
        guard self != old else { return [] }

        var result: [PartialKeyPath<Self>] = []
        result += intKeyPaths.filter { self[keyPath: $0] != old[keyPath: $0] }
        result += boolKeyPaths.filter { self[keyPath: $0] != old[keyPath: $0] }
        return result
    }

    var intKeyPaths: [KeyPath<Self, Int>] { [\.count, \.seconds] }
    var boolKeyPaths: [KeyPath<Self, Bool>] { [\.isNetworkReachable] }

}

enum StateChange {
    case countUp
    case countDown
}

protocol AppStateUpdatable {
    mutating func send(_ change: StateChange)
}

extension StateStore: AppStateUpdatable where State == AppState {
    func send(_ change: StateChange) {
        var state = self.state
        switch change {
        case .countUp:
            state.count += 1
        case .countDown:
            state.count -= 1
        }
        self.state = state
    }
    
}
