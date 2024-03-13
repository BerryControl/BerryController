//
//  PairDeviceView.swift
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

import Steps
import SwiftUI
import SwiftUIKit
import TypedAppStorage

struct PairDeviceView: View {
    
    // MARK: - Properties
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                steps[stepsState.currentIndex]
                    .view
                    .environmentObject(stepsState)
                    .environmentObject(pairDeviceStatus)
                    .environmentObject(devicePairingClient)
                    .padding(30)
                
                
                Spacer()
            }
            
            Spacer()
            
            Steps(state: stepsState, onCreateStep: { item in
                Step(title: item.title, image: nil)
            })
            .itemSpacing(10)
            .font(.caption)
            .padding()
            
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            self.devicePairingClient.connect(hub: self.connectedHub)
        }
    }
    
    
    // MARK: - Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    @ObservedObject
    private var stepsState: StepsState<PairDeviceStep>
    
    @ObservedObject
    private var pairDeviceStatus = PairDeviceStatus()
    
    @TypedAppStorage
    private var connectedHub: ConnectedBerryControlHub
    
    private let steps = [
        PairDeviceStep(
            title: "Select Driver",
            view: AnyView(SelectDriverStepView())),
        PairDeviceStep(
            title: "Select Device",
            view: AnyView(SelectDeviceStepView())),
        PairDeviceStep(
            title: "Pair Device",
            view: AnyView(PairDeviceStepView()))
    ]
    private var devicePairingClient = DevicePairingAPI()
    
    
    // MARK: - Initialization
    
    init() {
        stepsState = StepsState(data: steps as [PairDeviceStep])
    }
}

#Preview {
    PairDeviceView()
}
