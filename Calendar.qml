import QtQuick 2.15
import QtQuick.Window 2.15

/* OPENOS 日历 App (独立窗口)
 * 月历网格 + 今日高亮 + 切月 + 事件占位
 */
Window {
    id: calApp
    width: 340; height: 420
    flags: Qt.FramelessWindowHint
    title: "日历"
    color: OpenUI.background

    property var shownDate: new Date()

    Column {
        anchors.fill: parent; anchors.margins: OpenUI.sp4; spacing: OpenUI.sp2

        Row { width: parent.width; spacing: OpenUI.sp2
            Text { text: Qt.formatDate(shownDate, "yyyy年M月"); color: OpenUI.onSurface
                   font.pixelSize: OpenUI.typeHeadlineM; font.bold: true }
            Item { width: parent.width - 120; height: 1 }
            Repeater { model: [{icon:"chevron-left", ctx:"Navigation"}, {icon:"chevron-right", ctx:"Navigation"}]
                Rectangle { width: 28; height: 28; radius: OpenUI.shapeXs
                    color: hover.hovered ? Qt.rgba(OpenUI.onSurface.r, OpenUI.onSurface.g,
                                                   OpenUI.onSurface.b, OpenUI.hoverAlpha) : "transparent"
                    ThemedIcon { anchors.centerIn: parent; name: modelData.icon; ctx: modelData.ctx; size: 16; color: OpenUI.onSurfaceVariant }
                    MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true
                        onClicked: { var d = calApp.shownDate
                                     d.setMonth(d.getMonth() + (index === 0 ? -1 : 1))
                                     calApp.shownDate = d } }
                }
            }
        }

        Row { width: parent.width; spacing: 1
            Repeater { model: ["日","一","二","三","四","五","六"]
                Text { width: parent.width/7; horizontalAlignment: Text.AlignHCenter
                       text: modelData; color: OpenUI.onSurfaceVariant; font.pixelSize: OpenUI.typeLabelM } }
        }

        Grid { columns: 7; spacing: 1; width: parent.width
            Repeater { model: 42
                Rectangle {
                    width: parent.width/7 - 2; height: 36; radius: OpenUI.shapeXs
                    color: isToday() ? Qt.rgba(OpenUI.primary.r, OpenUI.primary.g,
                                              OpenUI.primary.b, 0.3) : "transparent"
                    function isToday() {
                        var d = calApp.shownDate
                        var first = new Date(d.getFullYear(), d.getMonth(), 1)
                        var dayNum = index - first.getDay() + 1
                        var now = new Date()
                        return dayNum === now.getDate() && d.getMonth() === now.getMonth()
                    }
                    Text { anchors.centerIn: parent
                        text: { var d = calApp.shownDate
                                var first = new Date(d.getFullYear(), d.getMonth(), 1)
                                return index - first.getDay() + 1 }
                        color: isToday() ? OpenUI.primary : OpenUI.onSurfaceVariant
                        font.pixelSize: OpenUI.typeLabelM }
                    MouseArea { anchors.fill: parent; hoverEnabled: true }
                }
            }
        }

        Item { width: 1; height: 8 }
        Text { text: "事件列表 (占位)"; color: OpenUI.onSurfaceVariant; font.pixelSize: OpenUI.typeLabelL }
        Rectangle { width: parent.width; height: 60; radius: OpenUI.shapeSm
            color: Qt.rgba(OpenUI.surfaceBright.r, OpenUI.surfaceBright.g,
                           OpenUI.surfaceBright.b, 0.3)
            Text { anchors.centerIn: parent; text: "无事件\n(生产: 对接 OAK/日历服务)"
                   color: OpenUI.onSurfaceDisabled; font.pixelSize: OpenUI.typeLabelM
                   horizontalAlignment: Text.AlignHCenter } }
    }

    Rectangle { x: parent.width - 40; y: 8; width: 32; height: 32; radius: OpenUI.shapeXs
        color: hover.hovered ? Qt.rgba(OpenUI.error.r, OpenUI.error.g,
                                       OpenUI.error.b, 0.3) : "transparent"
        ThemedIcon { anchors.centerIn: parent; name: "window-close"; ctx: "Actions"; size: 14; color: OpenUI.onSurface }
        MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true
            onClicked: calApp.close() } }
}
