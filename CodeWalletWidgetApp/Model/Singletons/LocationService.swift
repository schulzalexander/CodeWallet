//
//  LocationService.swift
//  CodeWalletWidgetApp
//
//  Created by Alexander Schulz on 30.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import Foundation
import MapKit
import UserNotifications

enum LocationAlertType: Int {
	case onEntry, onExit, both
}

class LocationService: NSObject {
	
	var locationManager: CLLocationManager!
	
	static var shared: LocationService = LocationService()
	
	private override init() {
		super.init()
		initLocationManager()
	}
	
	private func initLocationManager() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager = CLLocationManager()
			
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.allowsBackgroundLocationUpdates = true
//			if #available(iOS 11.0, *) {
//				locationManager.showsBackgroundLocationIndicator = false
//			}
		}
	}
	
	func registerLocalNotification(notification: LocationNotification) {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
			guard error == nil else {
				print("Error while requesting user notification authorization: \(error!.localizedDescription)")
				return
			}
			if !success {
				print("No success requesting user notification authorization!")
				return
			} else {
				guard let code = CodeManager.shared.getCode(id: notification.codeID) else {
					return
				}
				
				let content = UNMutableNotificationContent()
				content.body = NSLocalizedString("LocationNotificationMessage", comment: "")
				content.title = code.name
				content.sound = UNNotificationSound.default
				
				let trigger = UNLocationNotificationTrigger(region: notification.region, repeats: true)
				let request = UNNotificationRequest(identifier: notification.codeID, content: content, trigger: trigger)
				
				UNUserNotificationCenter.current().add(request) { (error) in
					guard error == nil else {
						print("Error with location notification: \(error!.localizedDescription).")
						return
					}
				}
			}
		}
	}
	
	func unregisterLocalNotification(notification: LocationNotification) {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.codeID])
	}
}
