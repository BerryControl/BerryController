//
//  DevicePairing.swift
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

import BerryOpenAPILib
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

class DevicePairingAPI: ObservableObject {
    
    // MARK: - Private Properties
    
    private var client: Client!
    
    
    // MARK: - Initialization
    
    public init() {
    }
    
    
    // MARK: - Public Methods
    
    public func connect(hub: ConnectedBerryControlHub) {
        client = Client(
            serverURL: URL(string: hub.url!)!,
            transport: URLSessionTransport()
        )
    }
    
    public func readDeviceDrivers() async throws -> [DeviceDriver] {
        let response = try await client.readDeviceDrivers()
        
        switch response {
        case .ok(let body):
            return try body.body.json.map { drv in
                DeviceDriver(
                    id: drv.driverId!,
                    displayName: drv.displayName!,
                    description: drv.description!,
                    authenticationMethod: DeviceDriver.AuthenticationMethod(rawValue: drv.authenticationMethod!.rawValue)!)
            }
        default:
            throw WebAPIError.readingDeviceDrivers(response: response)
        }
    }
    
    public func readDevices(driverId: String) async throws -> [DeviceInfo] {
        let response = try await client.readDevices(readDevicesParameter(driverId))
        
        switch response {
        case .ok(let body):
            return try body.body.json.map { devInfo in
                DeviceInfo(id: devInfo.deviceId!, name: devInfo.name!)
            }
            
        default:
            throw WebAPIError.readingDevices(response: response)
        }
    }
    
    private func readDevicesParameter(_ driverId: String) -> Operations.readDevices.Input {
        return Operations.readDevices.Input(path: Operations.readDevices.Input.Path(driverId: driverId))
    }
    
    public func startDevicePairing(driverId: String, deviceId: String) async throws -> PairingRequest {
        let response = try await client.startPairing(
            path: startDevicePairingParameter(driverId, deviceId),
            body: Operations.startPairing.Input.Body.json(Components.Schemas.StartPairingRequest(remoteName: DeviceInformation.name)))
        
        switch response {
        case .ok(let body):
            return PairingRequest(
                pairingRequest: try body.body.json.pairingRequest!,
                deviceProvidesPin: try body.body.json.deviceProvidesPin!)
            
        default:
            throw WebAPIError.startingDevicePairing(response: response)
        }
    }
    
    private func startDevicePairingParameter(_ driverId: String, _ deviceId: String) -> Operations.startPairing.Input.Path {
        return Operations.startPairing.Input.Path(driverId: driverId, deviceId: deviceId)
    }
    
    public func finalizeDevicPairing(driverId: String, deviceId: String, pairingRequestId: String, credentials: String, deviceProvidesPin: Bool) async throws -> FinalizedPairing {
        let response = try await client.finalizePairing(
            path: finalizeDevicePairingParameter(driverId, deviceId, pairingRequestId),
            body: Operations.finalizePairing.Input.Body.json(Components.Schemas.FinalizePairingRequest(pin: credentials, deviceProvidesPin: deviceProvidesPin)))
        
        switch response {
        case .ok(let body):
            return FinalizedPairing(deviceHasPaired: try body.body.json.deviceHasPaired!)
            
        default:
            throw WebAPIError.finalizingDevicePairing(response: response)
        }
    }
    
    private func finalizeDevicePairingParameter(_ driverId: String, _ deviceId: String, _ pairingRequestId: String) -> Operations.finalizePairing.Input.Path {
        return Operations.finalizePairing.Input.Path(driverId: driverId, deviceId: deviceId, pairingRequestId: pairingRequestId)
    }
}
