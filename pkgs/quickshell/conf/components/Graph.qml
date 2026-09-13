import QtQuick
import QtQuick.Shapes
import qs.config

Item {
    id: root

    property var samples: []
    property int capacity: 60
    property color lineColor: Appearance.colors.accent
    property real fillOpacity: 0.14

    readonly property var padded: {
        const missing = root.capacity - root.samples.length;
        return missing > 0 ? new Array(missing).fill(0).concat(root.samples) : root.samples.slice(-root.capacity);
    }

    implicitHeight: 56

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: root.lineColor
            strokeWidth: 2
            fillColor: Appearance.alpha(root.lineColor, root.fillOpacity)
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathPolyline {
                path: {
                    const values = root.padded;
                    const step = root.width / Math.max(1, values.length - 1);
                    const points = [Qt.point(0, root.height)];
                    for (let i = 0; i < values.length; i++)
                        points.push(Qt.point(step * i, root.height - Math.max(0, Math.min(1, values[i])) * root.height));
                    points.push(Qt.point(root.width, root.height));
                    return points;
                }
            }
        }
    }
}
