import Foundation
import XCTest

private struct ElementStringIDs {
    static let passwordOption = "Enter your password instead."
    static let mailButton = "Open Mail"
    static let mailAlert = "Please check your email"
    static let okButton = "OK"
}

class LoginCheckMagicLinkScreen: BaseScreen {
    let passwordOption: XCUIElement
    let mailButton: XCUIElement
    let mailAlert: XCUIElement

    init() {
        let app = XCUIApplication()
        passwordOption = app.buttons[ElementStringIDs.passwordOption]
        mailButton = app.buttons[ElementStringIDs.mailButton]
        mailAlert = app.alerts[ElementStringIDs.mailAlert]

        super.init(element: mailButton)
    }

    func proceedWithPassword() -> LoginPasswordScreen {
        passwordOption.tap()

        return LoginPasswordScreen()
    }

    func openMagicLink() -> LoginEpilogueScreen {
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        safari.launch()

        // Select the URL bar when Safari opens
        let urlBar = safari.otherElements["URL"]
        waitFor(element: urlBar, predicate: "exists == true")
        urlBar.tap()

        // Redirect to the deep link
        safari.textFields["URL"].typeText("http://localhost:8282/magic-link?scheme=wpdebug\n")

        // Accept the prompt to open the deep link
        safari.buttons.matching(identifier: "Open").firstMatch.tap()

        return LoginEpilogueScreen()
    }

    static func isLoaded() -> Bool {
        return XCUIApplication().buttons[ElementStringIDs.mailButton].exists
    }
}
