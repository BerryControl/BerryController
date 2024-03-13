//
//  PairedDevicesAPI.swift
//  BerryController
//
//  Created by Thomas Bonk on 05.03.24.
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

class PairedDevicesAPI: ObservableObject {
    
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
    
    public func readPairedDevices() async throws -> [PairedDevice] {
        let response = try await client.readPairedDevices()
        
        switch response {
        case .ok(let body):
            return try body.body.json.map { dev in
                PairedDevice(
                    id: dev.pairingId!,
                    driverId: dev.driverId!,
                    deviceId: dev.deviceId!,
                    deviceName: dev.deviceName!)
            }
            
        default:
            throw WebAPIError.readingPairedDevices(response: response)
        }
    }
    
    public func unpairDevice(pairingId: String) async throws {
        let response = try await client.unpairDevice(path: Operations.unpairDevice.Input.Path(pairingId: pairingId))
        
        switch response {
        case .noContent(_):
            return
            
        default:
            throw WebAPIError.unpairDevice(response: response)
        }
    }
    
    public func readDeviceCommands(pairingId: String) async throws -> [DeviceCommand] {
        let response = try await client.readDeviceCommands(path: Operations.readDeviceCommands.Input.Path(pairingId: pairingId))
        
        switch response {
        case .ok(let body):
            return try body.body.json.map(self.toDeviceCommand)
            
        default:
            throw WebAPIError.readDeviceCommands(response: response)
        }
    }
    
    private func toDeviceCommand(_ cmd: Components.Schemas.DeviceCommand) -> DeviceCommand {
        return DeviceCommand(
            pairingId: cmd.pairingId!,
            driverId: cmd.driverId!,
            deviceId: cmd.deviceId!,
            commandId: cmd.commandId!,
            name: cmd.name!,
            icon: Data(Array(cmd.icon!.data)))
    }
    
    public func readDeviceRemoteLayout(pairingId: String) async throws -> RemoteLayout {
        let response = try await client.readDeviceRemoteLayout(path: Operations.readDeviceRemoteLayout.Input.Path(pairingId: pairingId))
        
        //try await client.executeDeviceCommand(path: Operations.executeDeviceCommand.Input.Path)
        
        switch response {
        case .ok(let body):
            return RemoteLayout(
                width: try body.body.json.width!,
                height: try body.body.json.height!,
                buttons: try body.body.json.buttons!)
            
        default:
            throw WebAPIError.readDeviceRemoteLayout(response: response)
        }
    }
    
    public func executeCommand(pairingId: String, commandId: Int) async throws {
        let response = try await client.executeDeviceCommand(
            path: Operations.executeDeviceCommand.Input.Path(
                pairingId: pairingId, commandId: commandId))
        
        switch response {
        case .noContent(_):
            return
        
        default:
            throw WebAPIError.executeCommand(response: response)
        }
    }
}
