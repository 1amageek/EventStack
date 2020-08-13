//
//  Stacker.swift
//  Squirrel-iOS
//
//  Created by nori on 2020/08/13.
//

import UIKit

public protocol CommunicationProtocol {
    func send(_ data: [Stacker.Event])
}

public class Stacker {

    private static let numberOfLimit: Int = 200

    public struct Event: Identifiable, Codable {

        public enum EventType: String, Codable {
            case impression
            case engagement
            case action
        }

        public typealias ID = String

        public var id: ID

        public var type: EventType

        // who
        public var subject: String

        // whom
        public var object: String
    }

    public struct Options {
        public var numberOfLimit: Int = Stacker.numberOfLimit
    }

    public static let shared = Stacker()

    public private(set) var numberOfLimit: Int = Stacker.numberOfLimit

    public private(set) var data: [Event] = []

    public private(set) var communicator: Any?

    private var _didEnterBackgroundNotificationObserver: Any?

    public class func configure(_ options: Options?) {
        Stacker.shared.numberOfLimit = options?.numberOfLimit ?? Stacker.numberOfLimit
    }

    init() {
        self._didEnterBackgroundNotificationObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.send()
        }
    }

    private func send() {
        guard !data.isEmpty else { return }
        if let communicator = self.communicator as? CommunicationProtocol {
            communicator.send(data)
            self.data.removeAll()
        }
    }

    public class func set<T: CommunicationProtocol>(_ communicator: T) {
        Stacker.shared.communicator = communicator
    }

    public class func push(_ event: Event) {
        Stacker.shared.data.append(event)
        if Stacker.shared.data.count > Stacker.shared.numberOfLimit {
            Stacker.shared.send()
        }
    }

    public class func send<T: CommunicationProtocol>(_ communicator: T) {
        let data: [Event] = Stacker.shared.data
        communicator.send(data)
    }

}
