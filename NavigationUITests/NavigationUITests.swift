//
//  NavigationUITests.swift
//  NavigationUITests
//
//  Created by Павел Барташов on 28.10.2022.
//

import XCTest

final class NavigationUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testPhotoGallery() {
        // Переходим в Фото галерею
        let photoCell = app.tables.staticTexts["Фото"]
        XCTAssertTrue(photoCell.waitForExistence(timeout: 1))
        photoCell.tap()

        let collectionViews = app.collectionViews.element
        XCTAssertTrue(collectionViews.waitForExistence(timeout: 1))

        // Возвращаемся назад
        app.navigationBars["Фото галлерея"].buttons["Назад"].tap()
    }

    func testStatusSet() {
        // Устанавливаем статус
        let statusString = "Test status"
        let statusTextField = app.textFields.firstMatch
        let statusButton = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Установить статус"]/*[[".buttons.matching(identifier: \"Установить статус\").staticTexts[\"Установить статус\"]",".staticTexts[\"Установить статус\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssertTrue(statusTextField.waitForExistence(timeout: 1))
        XCTAssertTrue(statusButton.waitForExistence(timeout: 1))

        statusTextField.tap()
        statusTextField.typeText(statusString)

        statusButton.tap()

        let staticLabel = app.tables.cells
            .containing(.image, identifier:"person")
            .children(matching: .staticText)
            .matching(identifier: statusString)
            .element
        XCTAssertTrue(staticLabel.waitForExistence(timeout: 1))
    }
}
