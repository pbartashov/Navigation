//
//  NavigationUITests.swift
//  NavigationUITests
//
//  Created by Павел Барташов on 28.10.2022.
//

import XCTest
//import Navigation

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
        let photoCell = app.tables.staticTexts["titleLabelPhotosTableViewCell".localized]
        XCTAssertTrue(photoCell.waitForExistence(timeout: 1))
        photoCell.tap()

        let collectionViews = app.collectionViews.element
        XCTAssertTrue(collectionViews.waitForExistence(timeout: 1))

        // Возвращаемся назад
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func testStatusSet() {
        // Устанавливаем статус
        let statusString = "Test status"
        let statusTextField = app.textFields.firstMatch
        let statusButton = app.tables.staticTexts["setStatusButtonProfileHeaderView".localized]

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
