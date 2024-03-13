//
//  SelectDeviceStepView.swift
//  BerryController
//
//  Created by Thomas Bonk on 02.03.24.
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

import Steps
import SwiftUI
import SwiftUIKit

struct SelectDeviceStepView: View, ErrorAlerter {
    
    // MARK: - Properties
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
            VStack {
                HStack {
                    Text("Select Device:")
                    Spacer()
                }
                
                List(devices, id: \.id, selection: $selectedDevice) { device in
                    VStack(alignment: .leading) {
                        Text("\(device.name)")
                    }
                    .padding()
                }
                
                HStack {
                    Button("Back") {
                        pairDeviceStatus.selectedDevice = nil
                        stepsState.previousStep()
                    }
                    
                    Spacer()
                    
                    Button("Next") {
                        pairDeviceStatus.selectedDevice = devices.first(where: { $0.id == selectedDevice })
                        stepsState.nextStep()
                    }
                    .disabled(selectedDevice == nil)
                }
            }
            .onAppear(perform: self.readDevices)
            .onAppear {
                selectedDevice = pairDeviceStatus.selectedDevice?.id
            }
        }
        .alert(alert)
    }
    
    @StateObject
    var alert: AlertContext = AlertContext()
    
    
    // MARK: - Private Properties
    
    @EnvironmentObject
    private var stepsState: StepsState<PairDeviceStep>
    
    @EnvironmentObject
    private var pairDeviceStatus: PairDeviceStatus
    
    @EnvironmentObject
    private var devicePairingAPI: DevicePairingAPI
    
    @State
    private var isLoading = false
    
    @State
    private var selectedDevice: String?
    
    @State
    private var devices: [DeviceInfo] = []
    
    
    // MARK: - Private Methods
    
    private func readDevices() {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            let devices = try await devicePairingAPI.readDevices(driverId: pairDeviceStatus.selectedDriver!.id)
            
            self.devices.removeAll()
            self.devices.append(contentsOf: devices)
        } after: {
            self.isLoading = false
        }
    }
}

#Preview {
    SelectDeviceStepView()
}
