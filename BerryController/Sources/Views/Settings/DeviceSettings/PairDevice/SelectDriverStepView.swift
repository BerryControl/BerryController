//
//  SelectDriverStepView.swift
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

import Steps
import SwiftUI
import SwiftUIKit

struct SelectDriverStepView: View, ErrorAlerter {
    
    // MARK: - Properties
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
            VStack {
                HStack {
                    Text("Select Driver:")
                    Spacer()
                }
                
                List(deviceDrivers, id: \.id, selection: $selectedDriver) { driver in
                    VStack(alignment: .leading) {
                        Text("\(driver.displayName)")
                            .bold()
                            .padding(.bottom, 3)
                        Text("\(driver.description)")
                    }
                    .padding()
                }
                
                HStack {
                    Spacer()
                    Button("Next") {
                        pairDeviceStatus.selectedDriver = deviceDrivers.first(where: { $0.id == selectedDriver })
                        stepsState.nextStep()
                    }
                    .disabled(selectedDriver == nil)
                }
            }
            .onAppear(perform: self.readDeviceDrivers)
            .onAppear {
                selectedDriver = pairDeviceStatus.selectedDriver?.id
            }
            .padding()
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
    private var selectedDriver: String?
    
    @State
    private var deviceDrivers: [DeviceDriver] = []
    
    
    // MARK: - Private Methods
    
    private func readDeviceDrivers() {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            let drivers = try await devicePairingAPI.readDeviceDrivers()
            
            self.deviceDrivers.removeAll()
            self.deviceDrivers.append(contentsOf: drivers)
        } after: {
            self.isLoading = false
        }
    }
}

#Preview {
    SelectDriverStepView()
}
