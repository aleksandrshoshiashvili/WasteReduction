// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

struct KeyBoardNotification {
    var frame: CGRect = .zero
    var duration: Double = 0
    
    init(note: Notification) {
        if let userInfo = note.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] {
                let anyObjValue = value as AnyObject
                if let cgRectValue = anyObjValue.cgRectValue {
                    self.frame = cgRectValue
                }
            }
            if let value = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                self.duration = value
            }
        }
    }
}

struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
}

class Token {
    let token: NSObjectProtocol
    let center: NotificationCenter
    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    
    deinit {
        center.removeObserver(token)
    }
}

extension NotificationCenter {
    func addObserver<A>(descriptor: NotificationDescriptor<A>, using block: @escaping (A) -> ()) -> Token {
        let token = addObserver(forName: descriptor.name, object: nil, queue: nil, using: { note in
            block(descriptor.convert(note))
        })
        return Token(token: token, center: self)
    }
}
