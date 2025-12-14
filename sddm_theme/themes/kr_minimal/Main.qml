import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0
import Qt5Compat.GraphicalEffects 1.0

Rectangle {
    id: root
    width: 1920
    height: 1080

    Image {
        id: bg
        anchors.fill: parent
        source: "bg.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.7
    }

    FastBlur {
        anchors.fill: parent
        source: bg
        radius: 30
    }

    TextField {
        id: passwordInput
        width: 400
        height: 50
        anchors.centerIn: parent
        focus: true
        placeholderText: "Password"
        echoMode: TextInput.Password

        // login(user, password, sessionIndex)
        onAccepted: sddm.login("arch", text, sddm.sessionIndex)
    }
}

