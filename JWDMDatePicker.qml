import QtQuick 2.12

Rectangle
{
    property color fontColor: "black"
    property color prevMonthColor: "grey"
    property color nextMonthColor: "grey"
    property color borderColor: "grey"
    property color backgroundColor: "white"

    signal datePicked(date d)

    property int yearStart: new Date().getFullYear() - 150
    property int yearRange: 300
    property date theDate: new Date()
    property int monthStartWeekDay: (new Date(theDate.getFullYear(), theDate.getMonth(), 1).getDay() + 6) % 7;
    property int daysInMonth: new Date(theDate.getFullYear(), theDate.getMonth() + 1, 0).getDate();
    property int daysInPrevMonth: new Date(theDate.getFullYear(), theDate.getMonth(), 0).getDate();

    id: theJWDMDatePicker
    color: backgroundColor
    border.width: 1
    border.color: borderColor

    function setMonth(m)
    {
        var newYear = theDate.getFullYear()
        var newDay = theDate.getDay()
        theDate = new Date(newYear, m, newDay)
    }
    function setYear(y)
    {
        var newMonth = theDate.getMonth()
        var newDay = theDate.getDay()
        theDate = new Date(y, newMonth, newDay)
    }

    function addMonth(m)
    {
        var newMonth = theDate.getMonth()
        var newYear = theDate.getFullYear()
        var newDay = theDate.getDate()
        theDate = new Date(newYear, newMonth + m, newDay)
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
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        monthSelect.visible = false
                        yearSelect.visible = false
                        addMonth(-1)
                    }

                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text
            {
                id: monthText
                text: theDate.toLocaleDateString(Qt.locale(), "MMMM")
                anchors.left: leftKlick.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height
                anchors.right: yearText.left
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        yearSelect.visible = false
                        monthSelect.visible = !monthSelect.visible
                    }
                }
            }
            Text
            {
                id: yearText
                text: theDate.getFullYear()
                anchors.right: rightKlick.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height
                width: contentWidth + rightKlick.width / 2
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        yearSelect.currentIndex = theDate.getFullYear() - yearStart
                        monthSelect.visible = false
                        yearSelect.visible = !yearSelect.visible
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
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        monthSelect.visible = false
                        yearSelect.visible = false
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
                    visible: !yearSelect.visible && !monthSelect.visible
                    id: weekDays
                    width: parent.width
                    height: monthYear.height / 3 * 2
                    Repeater
                    {
                        model: 7
                        delegate: Text
                        {
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
                    visible: !yearSelect.visible && !monthSelect.visible
                    id: line
                    color: "grey"
                    height: 1
                    width: parent.width
                }
                Grid
                {
                    visible: !yearSelect.visible && !monthSelect.visible
                    columns: 7
                    id: daySelect
                    width: parent.width
                    height: theColumn.height - theDatePicker.border.width * 2 - line.height - line2.height - weekDays.height  - monthYear.height
                    Repeater
                    {
                        id: theRepeater
                        property int rows: (monthStartWeekDay == 0 ? 0 : 1) + (daysInMonth > 28 ? 5 : 4)
                        model: 7 * rows
                        delegate: Text
                        {
                            width: daySelect.width / 7
                            height: daySelect.height / theRepeater.rows
                            property date myDate: new Date(theDate.getFullYear(), theDate.getMonth(), (index - monthStartWeekDay + 1))
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: myDate.getDate() + "."
                            color: myDate.getMonth() > theDate.getMonth() ? nextMonthColor :
                                                                            myDate.getMonth() < theDate.getMonth() ? prevMonthColor : fontColor
                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    theDate = myDate
                                    datePicked(theDate)
                                }
                            }
                        }
                    }
                }
            }
            GridView
            {
                z: 1
                visible: false
                id: yearSelect
                anchors.fill: parent
                clip: true
                model: yearRange
                cellHeight: height / 4
                cellWidth: width / 4
                currentIndex: theDate.getFullYear() - yearStart
                delegate: Rectangle
                {
                    width: yearSelect.cellWidth
                    height: yearSelect.cellHeight
                    Text
                    {
                        text: yearStart + index
                        anchors.centerIn: parent
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            setYear(yearStart + index)
                            yearSelect.visible = false
                        }
                    }
                }
            }

            Grid
            {
                z: 1
                visible: false
                id: monthSelect
                anchors.fill: parent
                Repeater
                {
                    model: 12
                    Text {
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
                                monthSelect.visible = false
                            }
                        }
                    }
                }
            }

        }
    }
}

