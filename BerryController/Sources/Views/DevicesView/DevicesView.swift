//
//  DevicesView.swift
//  BerryController
//
//  Created by Thomas Bonk on 07.03.24.
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

struct DevicesView: View, ErrorAlerter {
    
    // MARK: - Properties
    
    var body: some View {
        ConnectionRequiredView {
            LoadingView(isLoading: $isLoading) {
                VStack(alignment: .center) {
                    Picker(selection: $pairingId) {
                        ForEach(devices, id: \.id) { device in
                            Text("\(device.deviceName)")
                                .tag(device.id)
                                .padding()
                        }
                    } label: {
                        EmptyView()
                    }
                    .fixedSize()
                    .padding()
                    
                    Spacer()
                    
                    RemoteView(
                        layout: $remoteLayout,
                        commands: $commands,
                        executor: self.commandExecutor(command:))
                    
                    Spacer()
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    readPairedDevices()
                }
            }
            .onChange(of: pairingId, self.readCommandsAndLayout)
        }
        .onAppear {
            pairedDeviceAPI.connect(hub: connectedHub)
        }
        .alert(alert)
    }
    
    @StateObject
    var alert: AlertContext = AlertContext()
    
    
    // MARK: - Private Properties
    
    @State
    private var isLoading = false
    
    @ObservedObject
    private var pairedDeviceAPI = PairedDevicesAPI()
    
    @TypedAppStorage
    private var connectedHub: ConnectedBerryControlHub
    
    @State
    private var devices: [PairedDevice] = []
    
    @State
    private var commands: [DeviceCommand] = []
    
    @State
    private var remoteLayout: RemoteLayout? = nil
    
    @State
    private var pairingId: String = ""
    
    
    // MARK: - Private Methods
    
    private func commandExecutor(command: DeviceCommand) {
        DispatchQueue.main.async {
            self.tryWithErrorAlert {
                try await pairedDeviceAPI.executeCommand(pairingId: pairingId, commandId: command.commandId)
            }
        }
    }
    
    private func readPairedDevices() {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            let devices = try await pairedDeviceAPI.readPairedDevices()
            
            DispatchQueue.main.async {
                self.devices.removeAll()
                self.devices.append(contentsOf: devices)
                
                if let device = self.devices.first {
                    self.pairingId = device.id
                }
            }
        } after: {
            self.isLoading = false
        }
    }
    
    private func readCommandsAndLayout() {
        pairedDeviceAPI.connect(hub: connectedHub)
        DispatchQueue.main.async {
            self.tryWithErrorAlert {
                self.isLoading = true
            } operation: {
                let commands = try await pairedDeviceAPI.readDeviceCommands(pairingId: pairingId)
                self.commands.removeAll()
                self.commands.append(contentsOf: commands)
                
                self.remoteLayout = try await pairedDeviceAPI.readDeviceRemoteLayout(pairingId: pairingId)
            } after: {
                self.isLoading = false
            }
        }
    }
}

#Preview {
    DevicesView()
}
