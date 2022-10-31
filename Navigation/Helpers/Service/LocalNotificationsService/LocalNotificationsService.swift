//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Павел Барташов on 31.10.2022.
//

import UserNotifications

final class LocalNotificationsService: NSObject {

    // MARK: - Properties

    weak var tabNavigator: TabNavigatorProtocol?

    private var center: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }

    // MARK: - Metods

    func registerForLatestUpdatesIfPossible() {
        center.requestAuthorization(
            options: [.sound, .badge, .provisional]
        ) { [weak self] granted, error in
            if granted {
                self?.registerUpdatesCategory()
                self?.scheduleNotification()
            }
        }
    }

    private func scheduleNotification() {
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Navigation app"
        content.body = "checkoutUpdatesLocalNotificationsService".localized
        content.categoryIdentifier = Notification.categoryID
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 19
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request)
    }

    private func registerUpdatesCategory() {
        center.delegate = self

        let showPosts = UNNotificationAction(identifier: Notification.Action.showProfile.id,
                                             title: "showProfileLocalNotificationsService".localized,
                                             options: .foreground)

        let showFavorites = UNNotificationAction(identifier: Notification.Action.showFavorites.id,
                                                 title: "showFavoritesLocalNotificationsService".localized,
                                                 options: .foreground)

        let showMap = UNNotificationAction(identifier: Notification.Action.showMap.id,
                                           title: "showMapLocalNotificationsService".localized,
                                           options: .foreground)

        let category = UNNotificationCategory(identifier: Notification.categoryID,
                                              actions: [showPosts, showFavorites, showMap],
                                              intentIdentifiers: [],
                                              options: [])
        center.setNotificationCategories([category])
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                tabNavigator?.switchTo(tab: .feed)

            case Notification.Action.showProfile.id:
                tabNavigator?.switchTo(tab: .profile)

            case Notification.Action.showFavorites.id:
                tabNavigator?.switchTo(tab: .favorites)

            case Notification.Action.showMap.id:
                tabNavigator?.switchTo(tab: .map)

            default:
                break
        }

        completionHandler()
    }
}
