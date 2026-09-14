import QtQuick
import qs.config

NumberAnimation {
  id: root

  property string speed: "std"

  duration: Appearance.anim[root.speed].duration
  easing.type: Easing.BezierSpline
  easing.bezierCurve: Appearance.anim[root.speed].curve
}
