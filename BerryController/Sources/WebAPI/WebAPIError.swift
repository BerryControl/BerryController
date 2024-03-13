//
//  WebAPIError.swift
//  BerryController
//
//  Created by Thomas Bonk on 01.03.24.
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

import Foundation

enum WebAPIError: Error {
    // MARK: - DevicePairingAPI
    
    case readingDeviceDrivers(response: Any)
    case readingDevices(response: Any)
    case startingDevicePairing(response: Any)
    case finalizingDevicePairing(response: Any)
    
    
    // MARK: - PAIREDDevicesAPI
    case readingPairedDevices(response: Any)
    case unpairDevice(response: Any)
    case readDeviceCommands(response: Any)
    case readDeviceRemoteLayout(response: Any)
    case executeCommand(response: Any)
}

// For each error type return the appropriate localized description
extension WebAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .readingDeviceDrivers(_):
            return NSLocalizedString(
                "An error occurred while reading the device drivers.",
                comment: "Error message"
            )
            
        case .readingDevices(_):
            return NSLocalizedString(
                "An error occurred while reading the devices for the device driver.",
                comment: "Error message"
            )
        
        case .startingDevicePairing(_):
            return NSLocalizedString(
                "An error occurred while starting the pairing of with the device.",
                comment: "Error message"
            )
            
        case .finalizingDevicePairing(_):
            return NSLocalizedString(
                "An error occurred while finalizing the pairing of with the device.",
                comment: "Error message"
            )
            
        case .readingPairedDevices(_):
            return NSLocalizedString(
                "An error occurred while reading the paired devices.",
                comment: "Error message"
            )
            
        case .unpairDevice(_):
            return NSLocalizedString(
                "An error occurred while unpairing the device.",
                comment: "Error message"
            )
            
        case .readDeviceCommands(_):
            return NSLocalizedString(
                "An error occurred while reading the commands for the device.",
                comment: "Error message"
            )
            
        case .readDeviceRemoteLayout(_):
            return NSLocalizedString(
                "An error occurred while reading the remote layout for the device.",
                comment: "Error message"
            )
            
        case .executeCommand(_):
            return NSLocalizedString(
                "An error occurred while executing the command.",
                comment: "Error message"
            )
        }
    }
}
