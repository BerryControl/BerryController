//
//  DevicesSettingsView.swift
//  BerryController
//
//  Created by Thomas Bonk on 03.02.24.
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

struct DevicesSettingsView: View, ErrorAlerter {
    
    // MARK: - Properties
    
    var body: some View {
        ConnectionRequiredView {
            LoadingView(isLoading: $isLoading) {
                ConfiguredDevicesList(devices: $devices, selectedDeviceId: $selectedDeviceId)
                    .toolbar {
                        Button {
                            presentPairDeviceSheet = true
                        } label: {
                            Image(systemName: "plus.square")
                        }
                        
                        Button {
                            self.unpairDevice(pairingId: selectedDeviceId!)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .disabled(selectedDeviceId == nil)
                    }
                    .sheet(isPresented: $presentPairDeviceSheet) {
                        presentPairDeviceSheet = false
                    } content: {
                        PairDeviceView()
                            .padding()
                            .frame(width: 400, height: 500)
                    }
                    .onAppear {
                        pairedDeviceAPI.connect(hub: connectedHub)
                    }
                    .onAppear(perform: self.readPairedDevices)
                    .onChange(of: presentPairDeviceSheet) {
                        self.readPairedDevices()
                    }
            }
        }.alert(alert)
    }
    
    @StateObject
    var alert: AlertContext = AlertContext()
    
    
    // MARK: - Private Properties
    
    @State
    private var presentPairDeviceSheet = false
    
    @State
    private var isLoading = false
    
    @State
    private var devices: [PairedDevice] = []
    
    @State
    private var selectedDeviceId: String?
    
    @ObservedObject
    private var pairedDeviceAPI = PairedDevicesAPI()
    
    @TypedAppStorage
    private var connectedHub: ConnectedBerryControlHub
    
    
    // MARK: - Private Methods
    
    private func readPairedDevices() {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            let devices = try await pairedDeviceAPI.readPairedDevices()
            
            DispatchQueue.main.async {
                self.devices.removeAll()
                self.devices.append(contentsOf: devices)
            }
        } after: {
            self.isLoading = false
        }
    }
    
    private func unpairDevice(pairingId: String) {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            try await pairedDeviceAPI.unpairDevice(pairingId: pairingId)
        } after: {
            self.isLoading = false
        }

    }
}

#Preview {
    DevicesSettingsView()
}
