import QtQuick
import qs.config

ColorAnimation {
  id: root

  property string speed: "fast"

  duration: Appearance.anim[root.speed].duration
  easing.type: Easing.BezierSpline
  easing.bezierCurve: Appearance.anim[root.speed].curve
}
