//
//  SettingsView.swift
//  BerryController
//
//  Created by Thomas Bonk on 26.02.24.
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
import SwiftUIKit

struct SettingsView: View {
    
    // MARK: - Properties
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    ConnectHubSettingsView()
                        .navigationTitle("Connect to BerryControl Hub")
                } label: {
                    Label("Connect to BerryControl Hub", systemImage: "externaldrive.connected.to.line.below")
                }
                .padding()
                .font(.title2)
                
                NavigationLink {
                    DevicesSettingsView()
                        .navigationTitle("Devices")
                } label: {
                    Label("Devices", systemImage: "homepod.and.appletv")
                }
                .padding()
                .font(.title2)
                
                NavigationLink {
                    Text("Remotes UI goes here.")
                        .navigationTitle("Remotes")
                } label: {
                    Label("Remotes", systemImage: "av.remote.fill")
                }
                .padding()
                .font(.title2)
            }
            .listStyle(.sidebar)
        } detail: {
            EmptyView()
        }
    
    }
}

#Preview {
    SettingsView()
}
