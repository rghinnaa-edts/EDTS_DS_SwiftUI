//
//  ActionHelper.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 09/09/26.
//

import SwiftUI

public class ActionHelper {
    
    public struct LongPressAttach: ViewModifier {
        public let minimumPressDuration: TimeInterval?
        public let onBegin: () -> Void
        public let onEnd: () -> Void

        public init(minimumPressDuration: TimeInterval?, onBegin: @escaping () -> Void, onEnd: @escaping () -> Void) {
            self.minimumPressDuration = minimumPressDuration
            self.onBegin = onBegin
            self.onEnd = onEnd
        }

        public func body(content: Content) -> some View {
            if let duration = minimumPressDuration {
                content.onLongPressGesture(
                    minimumDuration: duration,
                    pressing: { pressing in if !pressing { onEnd() } },
                    perform: { onBegin() }
                )
            } else {
                content
            }
        }
    }
    
}
