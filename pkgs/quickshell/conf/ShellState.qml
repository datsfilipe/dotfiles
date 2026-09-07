pragma Singleton

import Quickshell

Singleton {
    property bool widgetShelfVisible: false
    property string widgetShelfPage: "calendar"

    function showWidget(page) {
        if (widgetShelfVisible && widgetShelfPage === page)
            widgetShelfVisible = false
        else {
            widgetShelfPage = page
            widgetShelfVisible = true
        }
    }
}
