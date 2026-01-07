import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

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

   Rectangle {
       anchors.fill: parent
       color: "#1A1B26"
       opacity: 0.35
   }

//    TextField {
//        id: passwordInput
//        width: 450
//        height: 120
//        anchors.centerIn: parent
//        focus: true
//        placeholderText: "Password"
//        echoMode: TextInput.Password
//
//        // login(user, password, sessionIndex)
//        onAccepted: sddm.login("arch", text, sddm.sessionIndex)
//    }

    TextField {
        id: passwordInput
        width: 450
        height: 120
        anchors.centerIn: parent
        focus: true

        echoMode: TextInput.Password
        placeholderText: ""          // matches your empty placeholder
        placeholderTextColor: "#99FFFFFF"

        color: "#C8C8C8"
        font.family: "SF Pro Display"
        font.bold: true
        font.pixelSize: 28

        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter

        // padding similar to hyprlock centered field
        leftPadding: 12
        rightPadding: 12
        topPadding: 8
        bottomPadding: 8

        property bool failed: false

        background: Rectangle {
           radius: 0
           color: "#801A1B26"            // inner_color rgba(26,27,38,0.5)
           border.width: 5              // outline_thickness
           border.color: passwordInput.failed ? "#F7768E" : "#9ECE6A"
        // fail_color rgba(247,118,142,1.0) -> #F7768E
        // outer_color rgba(158,206,106,1.0) -> #9ECE6A
    }

    onAccepted: {
        failed = false
        sddm.login("arch", text, sddm.sessionIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordInput.failed = true
            passwordInput.clear()
            passwordInput.forceActiveFocus()
        }
    }
    }
}



