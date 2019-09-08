import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle
{
    property color backgroundColor: "white"
    property color borderColor: "grey"
    property int yearStart: new Date().getFullYear() - 150
    property int yearRange: 300
    property date currentDate: new Date(yearTumbler.currentIndex + yearStart, monthTumbler.currentIndex, dayTumbler.currentIndex + 1)
    color: backgroundColor
    border.width: 1
    border.color: borderColor
    property alias font: templateText.font
    property color fontColor: "black"
    property bool dateGood: currentDate.toLocaleDateString(Qt.locale(), "yyyyMd")
                            == (yearStart + yearTumbler.currentIndex).toString() + (monthTumbler.currentIndex + 1).toString() + (dayTumbler.currentIndex + 1).toString()
    property bool showButtons: true
    function init(d)
    {
        dayTumbler.currentIndex = d.getDate() - 1
        yearTumbler.currentIndex = d.getFullYear() - yearStart
        monthTumbler.currentIndex = d.getMonth()
    }
    signal datePicked(date d)
    signal noDatePicked()

    // private
    property int buttonHeight: showButtons ? buttonRow.height + 1 : 1
    property color internalFontColor: dateGood ? fontColor : "red"

    id: theJWDMDateTumbler
    Text
    {
        id: templateText
        visible: false
    }
    Row
    {
        width: parent.width - 2
        height: parent.height - 2 - buttonHeight
        anchors.centerIn: parent
        anchors.verticalCenterOffset: - buttonHeight / 2
        Tumbler
        {
            id: dayTumbler
            width: parent.width / 4
            height: parent.height
            wrap:true
            model: 31
            delegate: Text
            {
                text: index + 1
                font: theJWDMDateTumbler.font
                color: internalFontColor
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            }
        }
        Rectangle
        {
            width: 1
            height: parent.height
            color: borderColor
        }

        Tumbler
        {
            width: parent.width / 2 - 2
            height: parent.height
            model: 12
            id: monthTumbler
            wrap:true
            delegate: Text
            {
                width: parent.width
                height: parent.height
                font: theJWDMDateTumbler.font
                color: internalFontColor
                text: new Date(1978, index, 1).toLocaleString(Qt.locale(), "MMMM")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            }
        }
        Tumbler
        {
            Rectangle
            {
                width: 1
                height: parent.height
                color: borderColor
            }
            id: yearTumbler
            width: parent.width / 4
            height: parent.height
            wrap:true
            model: yearRange
            delegate: Text
            {
                width: parent.width
                height: parent.height
                font: theJWDMDateTumbler.font
                text: yearStart + index
                color: internalFontColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            }
        }
    }
    Rectangle
    {
        width: parent.width
        height: 1
        color: borderColor
        visible: showButtons
        anchors.bottom: buttonRow.top
    }

    Row
    {
        id: buttonRow
        visible: showButtons
        width: parent.width - 2
        height: parent.height / 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter
        Text
        {
            width: parent.width / 2
            font: theJWDMDateTumbler.font
            height: parent.height
            color: internalFontColor
            text: qsTr("Ok")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if (!dateGood)
                    {
                        return
                    }
                    datePicked(currentDate)
                }
            }
        }
        Rectangle
        {
            width: 1
            height: parent.height
            color: borderColor
        }

        Text
        {
            text: qsTr("Abbrechen")
            font: theJWDMDateTumbler.font
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: internalFontColor
            width: parent.width / 2 - 1
            height: parent.height
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    noDatePicked()
                }
            }
        }
    }
}
