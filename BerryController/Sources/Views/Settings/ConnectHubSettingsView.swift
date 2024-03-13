//
//  ConnectHubSettingsView.swift
//  BerryController
//
//  Created by Thomas Bonk on 27.02.24.
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
import TypedAppStorage

struct ConnectHubSettingsView: View {
    
    // MARK: - Properties
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text("BerryController Hubs")
                    Spacer()
                }
                
                List(Array(hubBrowser.services), id: \.self, selection: $selectedService) { service in
                    Text("\(service.name)")
                        .tag(service)
                }
                .onChange(of: selectedService) {
                    connectedHub = ConnectedBerryControlHub(url: selectedService?.url, name: selectedService?.name)
                }
            }
            .padding([.horizontal], geo.size.width / 4)
            .padding([.vertical], 40)
            .onAppear {
                selectedService = hubBrowser.services.first(where: { $0.id == connectedHub.url })
            }
        }
    }
    
    
    // MARK: - Private Properties
    
    @TypedAppStorage
    private var connectedHub: ConnectedBerryControlHub
    
    @EnvironmentObject
    private var hubBrowser: BerryControlHubBrowser
    
    @State
    private var selectedService: NetService?
}

#Preview {
    ConnectHubSettingsView()
}
