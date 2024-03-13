//
//  DeviceDriver.swift
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

struct DeviceDriver: Identifiable, Hashable {
    
    // MARK: - Enums
    
    public enum AuthenticationMethod: String, RawRepresentable {
        case None = "NONE"
        case Pin = "PIN"
        case Password = "PASSWORD"
        case UserAndPassword = "USER_AND_PASSWORD"
    }
    
    
    // MARK: - Properties
    
    /// The ID of the device driver.
    public let id: String
    /// Name of the device driver; might be displayed in a UI.
    public let displayName: String
    /// Description for the plugin that might be displayed in a UI.
    public let description: String
    /// The authentication method to be used when connecting to a device provided by the driver.
    public let authenticationMethod: AuthenticationMethod
}
