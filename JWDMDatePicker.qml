import QtQuick 2.12

Rectangle
{
    property color fontColor: "black"
    property color prevMonthColor: "grey"
    property color nextMonthColor: "grey"
    property color borderColor: "grey"
    property color backgroundColor: "white"
    property alias font: templateText.font

    signal datePicked(date d)

    property int yearStart: new Date().getFullYear() - 150
    property int yearRange: 300
    property date currentDate: new Date()

    function init(d)
    {
        currentDate = d
    }

    // private
    Text
    {
        id: templateText
        visible: false
    }
    property int monthStartWeekDay: (new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay() + 6) % 7;
    property int daysInMonth: new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate();
    property int daysInPrevMonth: new Date(currentDate.getFullYear(), currentDate.getMonth(), 0).getDate();

    id: theJWDMDatePicker
    color: backgroundColor
    border.width: 1
    border.color: borderColor

    function setMonth(m)
    {
        var newYear = currentDate.getFullYear()
        var newDay = currentDate.getDay()
        currentDate = new Date(newYear, m, newDay)
    }
    function setYear(y)
    {
        var newMonth = currentDate.getMonth()
        var newDay = currentDate.getDay()
        currentDate = new Date(y, newMonth, newDay)
    }

    function addMonth(m)
    {
        var newMonth = currentDate.getMonth()
        var newYear = currentDate.getFullYear()
        var newDay = currentDate.getDate()
        currentDate = new Date(newYear, newMonth + m, newDay)
    }
    Column
    {
        id: theColumn
        width: theJWDMDatePicker.width - 2
        height: theJWDMDatePicker.height - 2
        anchors.centerIn: parent
        Item
        {
            id: monthYear
            width: parent.width
            height: width / 6
            Text
            {
                id: leftKlick
                text: "<"
                height: parent.height
                width: height
                color: theJWDMDatePicker.fontColor
                font: theJWDMDatePicker.font
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        monthSelect.opacity = 0
                        yearSelect.opacity = 0
                        addMonth(-1)
                    }

                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                id: monthText
                text: currentDate.toLocaleDateString(Qt.locale(), "MMMM")
                anchors.left: leftKlick.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height
                anchors.right: yearText.left
                color: theJWDMDatePicker.fontColor
                font: theJWDMDatePicker.font
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        yearSelect.opacity = 0
                        if (monthSelect.opacity > 0)
                        {
                            monthSelect.opacity = 0
                        }
                        else
                        {
                            monthSelect.opacity = 1
                        }
                    }
                }
            }
            Text
            {
                id: yearText
                text: currentDate.getFullYear()
                anchors.right: rightKlick.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height
                width: contentWidth + rightKlick.width / 2
                color: theJWDMDatePicker.fontColor
                font: theJWDMDatePicker.font
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        yearSelect.currentIndex = currentDate.getFullYear() - yearStart
                        monthSelect.opacity = 0
                        if (yearSelect.opacity > 0)
                        {
                            yearSelect.opacity = 0
                        }
                        else
                        {
                            yearSelect.opacity = 1
                        }
                    }
                }
            }
            Text
            {
                id: rightKlick
                text: ">"
                anchors.right: parent.right
                height: parent.height
                width: height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: theJWDMDatePicker.fontColor
                font: theJWDMDatePicker.font
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        monthSelect.opacity = 0
                        yearSelect.opacity = 0
                        addMonth(1)
                    }
                }
            }

        }
        Rectangle
        {
            color: "grey"
            height: 1
            width: parent.width
            id: line2
        }
        Item
        {
            width: parent.width
            height: dayMonthYear.height
            Column
            {
                id: dayMonthYear
                height: weekDays.height + line.height + daySelect.height
                width: parent.width
                Row
                {
                    visible: opacity > 0
                    opacity: daySelect.opacity
                    id: weekDays
                    width: parent.width
                    height: monthYear.height / 3 * 2
                    Repeater
                    {
                        model: 7
                        delegate: Text
                        {
                            color: theJWDMDatePicker.fontColor
                            font: theJWDMDatePicker.font
                            text: (new Date(1978, 5, 23 + index - 4)).toLocaleDateString(Qt.locale(), "ddd")
                            width: weekDays.width / 7
                            height: weekDays.height
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
                Rectangle
                {
                    visible: opacity > 0
                    opacity: daySelect.opacity
                    id: line
                    color: "grey"
                    height: 1
                    width: parent.width
                }
                Grid
                {
                    visible: opacity > 0
                    opacity: 1 - yearSelect.opacity - monthSelect.opacity
                    columns: 7
                    id: daySelect
                    width: parent.width
                    height: theColumn.height - theJWDMDatePicker.border.width * 2 - line.height - line2.height - weekDays.height  - monthYear.height
                    Repeater
                    {
                        id: theRepeater
                        property int rows: (monthStartWeekDay == 0 ? 0 : 1) + (daysInMonth > 28 ? 5 : 4)
                        model: 7 * rows
                        delegate: Text
                        {
                            font: theJWDMDatePicker.font
                            width: daySelect.width / 7
                            height: daySelect.height / theRepeater.rows
                            property date myDate: new Date(currentDate.getFullYear(), currentDate.getMonth(), (index - monthStartWeekDay + 1))
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: myDate.getDate() + "."
                            color: myDate.getMonth() > currentDate.getMonth() ? nextMonthColor :
                                                                                myDate.getMonth() < currentDate.getMonth() ? prevMonthColor : fontColor
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    currentDate = myDate
                                    datePicked(currentDate)
                                }
                            }
                            Rectangle
                            {
                                anchors.centerIn: parent
                                width: height
                                height: parent.contentHeight * 1.7
                                radius: width / 2
                                color: "transparent"
                                border.width: 1
                                border.color: theJWDMDatePicker.borderColor
                                visible: parent.myDate.getTime() == currentDate.getTime()
                            }
                        }
                    }
                }
            }
            GridView
            {
                z: 1
                visible: opacity > 0
                opacity: 0
                Behavior on opacity {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }

                id: yearSelect
                anchors.fill: parent
                clip: true
                model: yearRange
                cellHeight: height / 4
                cellWidth: width / 4
                currentIndex: currentDate.getFullYear() - yearStart
                delegate:                    Text
                {
                    width: yearSelect.cellWidth
                    height: yearSelect.cellHeight
                    font: theJWDMDatePicker.font
                    color: theJWDMDatePicker.fontColor
                    text: yearStart + index
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            setYear(yearStart + index)
                            yearSelect.opacity = 0
                        }
                    }
                    Rectangle
                    {
                        anchors.centerIn: parent
                        width: parent.width * 4 / 5
                        height: parent.contentHeight * 1.5
                        radius: 5
                        color: "transparent"
                        border.width: 1
                        border.color: theJWDMDatePicker.borderColor
                        visible: parent.text == currentDate.getFullYear().toString()
                    }
                }
            }

            Grid
            {
                z: 1
                visible: opacity > 0
                opacity: 0
                Behavior on opacity {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }
                id: monthSelect
                anchors.fill: parent
                Repeater
                {
                    model: 12
                    Text {
                        font: theJWDMDatePicker.font
                        color: theJWDMDatePicker.fontColor
                        width: monthSelect.width / 4
                        height: monthSelect.height / 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: (new Date(1978, index, 1)).toLocaleDateString(Qt.locale(), "MMM")
                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                setMonth(index)
                                monthSelect.opacity = 0
                            }
                        }
                        Rectangle
                        {
                            anchors.centerIn: parent
                            width: parent.width * 4 / 5
                            height: parent.contentHeight * 1.5
                            radius: 5
                            color: "transparent"
                            border.width: 1
                            border.color: theJWDMDatePicker.borderColor
                            visible: parent.text == currentDate.toLocaleDateString(Qt.locale(), "MMM")
                        }
                    }
                }
            }

        }
    }
}

