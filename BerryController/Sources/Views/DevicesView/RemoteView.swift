//
//  RemoteView.swift
//  BerryController
//
//  Created by Thomas Bonk on 11.03.24.
//  Copyright 2024 Thomas Bonk
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct RemoteView: View {
    
    // MARK: - Properties
    
    var body: some View {
        if let layout {
            Grid {
                ForEach((0..<layout.height)) { row in
                    GridRow {
                        ForEach((0..<layout.width)) { column in
                            if layout.buttons[row][column] >= 0 {
                                Button {
                                    executor(command(for: layout.buttons[row][column]))
                                } label: {
                                    #if canImport(UIKit)
                                    Image(uiImage: UIImage(data: command(for: layout.buttons[row][column]).icon)!)
                                    #elseif canImport(AppKit)
                                    Image(nsImage: NSImage(data: command(for: layout.buttons[row][column]).icon)!)
                                    #endif
                                }
                                .help(command(for: layout.buttons[row][column]).name)
                            } else {
                                // TODO find a better way to represent an empty cell
                                Text("")
                            }
                        }
                    }
                }
            }
        } else {
            VStack {
                Spacer()
                Text("No remote layout avaliable!")
                Spacer()
            }
        }
    }
    
    @Binding
    var layout: RemoteLayout?
    
    @Binding
    var commands: [DeviceCommand]
    
    var executor: (DeviceCommand) -> Void
    
    
    // MARK: - Private Methods
    
    private func command(for id: Int) -> DeviceCommand {
        return commands.first {
            $0.commandId == id
        }!
    }
}
