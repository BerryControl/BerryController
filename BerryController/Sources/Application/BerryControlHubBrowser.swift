//
//  BerryControlHubBrowser.swift
//  BerryController
//
//  Created by Thomas Bonk on 01.02.24.
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

import Ciao
import SwiftUI
import SwiftUIKit

extension NetService {
    
    var ipAddress: String? {
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        
        guard
            let data = self.addresses?.first 
        else {
            return nil
        }
        
        data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Void in
                let sockaddrPtr = pointer.bindMemory(to: sockaddr.self)
                guard let unsafePtr = sockaddrPtr.baseAddress else { return }
                guard getnameinfo(unsafePtr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    return
                }
            }
        
        return String(cString:hostname)
    }
    
    var url: String? {
        return self.txtRecordDictionary?["url"]
    }
}

extension NetService: Identifiable {
    public var id: String {
        return self.url!
    }
}

class BerryControlHubBrowser: NSObject, ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    public private(set) var services: Set<NetService> = []
    
    @Published
    public private(set) var connectedService: NetService?
    
    
    // MARK: - Private Properties
    
    private let ciaoBrowser = CiaoBrowser()
    
    
    // MARK: - Initialization
    
    public override init() {
        super.init()

        // register to automatically resolve a service
        ciaoBrowser.serviceResolvedHandler = { result in
            switch result {
            case Result.success(let service):
                self.services.insert(service)
                break
                
            case Result.failure(let errorDict):
                print(errorDict)
            }
        }

        ciaoBrowser.serviceRemovedHandler = { service in
            self.services.remove(service)
        }

        ciaoBrowser.browse(type: ServiceType.tcp("berry-ctrl-hub"))
    }
    
    
    // MARK: - Public Methods
    
    public func connect(service: NetService) {
        self.connectedService = service
    }
    
    public func disconnectService() {
        self.connectedService = nil
    }
}
