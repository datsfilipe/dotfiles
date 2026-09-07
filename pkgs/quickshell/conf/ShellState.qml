pragma Singleton

import Quickshell

Singleton {
    property bool widgetShelfVisible: false
    property string widgetShelfPage: "weather"
    property bool wallpaperPickerVisible: false

    function showWidget(page) {
        if (widgetShelfVisible && widgetShelfPage === page)
            widgetShelfVisible = false
        else {
            widgetShelfPage = page
            widgetShelfVisible = true
        }
    }
}
