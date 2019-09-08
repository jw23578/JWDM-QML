import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle
{
    property color backgroundColor: "white"
    property color borderColor: "grey"
    property int yearStart: new Date().getFullYear() - 150
    property int yearRange: 300
    property date theDate: new Date()
    border.width: 1
    border.color: borderColor
    property int fontPixelSize: templateText.font.pixelSize
    property bool dateGood: new Date(yearTumbler.currentIndex + yearStart, monthTumbler.currentIndex, dayTumbler.currentIndex + 1).toLocaleDateString(Qt.locale(), "yyyyMd")
                            == (yearStart + yearTumbler.currentIndex).toString() + (monthTumbler.currentIndex + 1).toString() + (dayTumbler.currentIndex + 1).toString()
    function init(d)
    {
        theDate = d
        dayTumbler.currentIndex = theDate.getDate() - 1
        yearTumbler.currentIndex = theDate.getFullYear() - yearStart
        monthTumbler.currentIndex = theDate.getMonth()
    }

    signal datePicked(date d)
    signal noDatePicked()
    id: theJWDMDateTumbler
    Text
    {
        id: templateText
        visible: false
    }
    Row
    {
        width: parent.width - 2
        height: parent.height - 2
        anchors.centerIn: parent
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
                color: dateGood ? "black" : "red"
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
                color: dateGood ? "black" : "red"
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
                text: yearStart + index
                color: dateGood ? "black" : "red"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            }
        }
    }
    Rectangle
    {
        width: parent.width / 2
        height: parent.height / 10
        anchors.bottom: parent.bottom
        border.width: 1
        border.color: borderColor
        Text {
            text: qsTr("Ok")
            anchors.centerIn: parent
        }
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                if (!dateGood)
                {
                    return
                }
                datePicked(new Date(yearTumbler.currentIndex + yearStart, monthTumbler.currentIndex, dayTumbler.currentIndex + 1))
            }
        }
    }
    Rectangle
    {
        width: parent.width / 2
        height: parent.height / 10
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        border.width: 1
        border.color: borderColor
        Text {
            text: qsTr("Abbrechen")
            anchors.centerIn: parent
        }
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
