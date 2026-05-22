//
//  CaseSteppable.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

/// A protocol that provides utility properties for navigating through the cases of an enumeration.
///
/// `CaseSteppable` requires the conforming type to be `CaseIterable` and `Equatable`,
/// and the `AllCases` collection must support bidirectional traversal.
protocol CaseSteppabble: CaseIterable, Equatable where AllCases: BidirectionalCollection {
    /// A Boolean value indicating whether the current case is the first element in the collection.
    ///
    /// - Returns: true if it's the first element in the collection
    var isFirst: Bool { get }

    /// A Boolean value indicating whether the current case is the last element in the collection.
    ///
    /// - Returns: true if it's the last element in the collection
    var isLast: Bool { get }

    /// The previous case in the sequence of all cases.
    ///
    /// - Returns: The preceding case, or `nil` if the current case is the first element.
    var previous: Self? { get }

    /// The next case in the sequence of all cases.
    ///
    /// - Returns: The subsequent case, or `nil` if the current case is the last element.
    var next: Self? { get }
}

/// Default implementation providing logic for index-based navigation.
extension CaseSteppabble {
    var isFirst: Bool {
        return self == Self.allCases.first
    }

    var isLast: Bool {
        return self == Self.allCases.last
    }

    var previous: Self? {
        let all = Self.allCases
        guard let currentIndex = all.firstIndex(of: self) else { return nil }
        let prevIndex = all.index(before: currentIndex)
        return all.indices.contains(prevIndex) ? all[prevIndex] : nil
    }

    var next: Self? {
        let all = Self.allCases
        guard let currentIndex = all.firstIndex(of: self) else { return nil }
        let nextIndex = all.index(after: currentIndex)
        return all.indices.contains(nextIndex) ? all[nextIndex] : nil
    }
}
