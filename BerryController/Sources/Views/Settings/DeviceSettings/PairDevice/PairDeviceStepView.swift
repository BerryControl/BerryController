//
//  FinishPairDeviceStepView.swift
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

struct PairDeviceStepView: View, ErrorAlerter {
    
    // MARK: - Properties
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
            VStack {
                credentialsView()
                
                Spacer()
                
                HStack {
                    Button("Back") {
                        pairDeviceStatus.pairingRequest = nil
                        pairDeviceStatus.finalizedPairing = nil
                        stepsState.previousStep()
                    }
                    
                    Spacer()
                    
                    Button("Pair", action: self.finalizePairing)
                        .disabled(self.cannotPair())
                }
            }
        }
        .onAppear(perform: self.startPairing)
        .alert(alert)
    }
    
    @StateObject
    var alert: AlertContext = AlertContext()
    
    
    // MARK: - Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var isLoading = false
    
    @State
    private var password: String = ""
    
    @EnvironmentObject
    private var stepsState: StepsState<PairDeviceStep>
    
    @EnvironmentObject
    private var devicePairingAPI: DevicePairingAPI
    
    @EnvironmentObject
    private var pairDeviceStatus: PairDeviceStatus
    
    
    // MARK: - Pricate Methods
    
    private func cannotPair() -> Bool {
        let result = self.pairDeviceStatus.pairingRequest == nil
        || (self.pairDeviceStatus.finalizedPairing != nil
            && !self.pairDeviceStatus.finalizedPairing!.deviceHasPaired)
        
        if (self.pairDeviceStatus.finalizedPairing != nil
            && self.pairDeviceStatus.finalizedPairing!.deviceHasPaired) {
            dismiss()
        }
        
        return result
    }
    
    @ViewBuilder
    private func credentialsView() -> some View {
        switch pairDeviceStatus.selectedDriver!.authenticationMethod {
        case DeviceDriver.AuthenticationMethod.None:
            Text("Please press the button 'Pair' to finish pairing of the device!")
            
        case DeviceDriver.AuthenticationMethod.Pin:
            if let pairingRequest = self.pairDeviceStatus.pairingRequest {
                if pairingRequest.deviceProvidesPin {
                    HStack {
                        Text("PIN:").padding(.trailing, 5)
                        TextField("Enter PIN displayed on device", text: $password)
                    }
                } else {
                    Text("Please Enter the PIN \(Int.random(in: 1000..<9999)) on the device.")
                }
            } else {
                EmptyView()
            }
            
        case DeviceDriver.AuthenticationMethod.Password:
            Text("PASSWORD")
            
        case DeviceDriver.AuthenticationMethod.UserAndPassword:
            Text("USER_AND_PASSWORD")
        }
    }
    
    private func startPairing() {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            self.pairDeviceStatus.pairingRequest = try await devicePairingAPI
                .startDevicePairing(
                    driverId: self.pairDeviceStatus.selectedDriver!.id,
                    deviceId: self.pairDeviceStatus.selectedDevice!.id)
        } after: {
            self.isLoading = false
        }
    }
    
    private func finalizePairing() {
        self.tryWithErrorAlert {
            self.isLoading = true
        } operation: {
            self.pairDeviceStatus.finalizedPairing = try await devicePairingAPI
                .finalizeDevicPairing(
                    driverId: self.pairDeviceStatus.selectedDriver!.id,
                    deviceId: self.pairDeviceStatus.selectedDevice!.id,
                    pairingRequestId: self.pairDeviceStatus.pairingRequest!.pairingRequest,
                    credentials: password,
                    deviceProvidesPin: self.pairDeviceStatus.pairingRequest!.deviceProvidesPin)
        } after: {
            self.isLoading = false
        }
    }
}

#Preview {
    PairDeviceStepView()
}
