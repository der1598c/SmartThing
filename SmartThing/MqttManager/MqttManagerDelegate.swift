//
//  MqttManagerDelegate.swift
//  SmartThing
//
//  Created by Leyee.H on 2019/11/23.
//  Copyright © 2019 Leyee. All rights reserved.
//

import Foundation

protocol MqttManagerDelegate: class {
    func onMqttConnected()
    func onMqttDisconnected()
    func onMqttMessageReceived(message: String, topic: String)
    func onMqttError(message: String)
}
