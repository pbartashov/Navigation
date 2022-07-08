//
//  HintModel.swift
//  Navigation
//
//  Created by Павел Барташов on 06.07.2022.
//

enum Position {
    case first
    case middle
    case last
}

typealias HintElement = (value: String, position: Position)

struct HintModel {

    //MARK: - Properties

    private let hints = [
        "Вот несколько примеров использования таймеров:",
        "Отображение подсказок пользователю, например, если он несколько секунд не предпринимает никаких действий, можно подсказать ему какую кнопку нажать и какое действие она выполнит.",

        "Обновление информации в приложении. По таймеру можно запускать процессы синхронизации данных с сервером.",

        "Контроль состояния приложения, например, для записи логов или запуска каких-то процессов в зависимости от значения текущих параметров.",

        "Создание архивных копий (бэкап)."
    ]

    private var currentIndex: Int = 0

    var first: HintElement? {
        hints.isEmpty ? nil : (value: hints.first!, position: .first)
    }

    var current: HintElement? {
        switch currentIndex {
            case 0:
                return first

            case hints.count - 1:
                return last

            default:
                break
        }

        return (value: hints[currentIndex], position: .middle)
    }

    var last: HintElement? {
        hints.isEmpty ? nil : (value: hints.last!, position: .first)
    }

    //MARK: - Metods

    mutating func next() -> (value: String, position: Position)? {

        currentIndex += 1

        if currentIndex == hints.count - 1 {
            return (value: hints[currentIndex], position: .last)
        } else if currentIndex >= hints.count {
            currentIndex = hints.count - 1
            return nil
        }

        return (value: hints[currentIndex], position: .middle)
    }

    mutating func previous() -> (value: String, position: Position)? {
        currentIndex -= 1

        if currentIndex == 0 {
            return (value: hints[0], position: .first)
        } else if  currentIndex < 0 {
            currentIndex = 0
            return nil
        }

        return (value: hints[currentIndex], position: .middle)
    }

    mutating func reset() {
        currentIndex = 0
    }
}
