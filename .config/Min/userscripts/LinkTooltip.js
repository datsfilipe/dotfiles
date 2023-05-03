// ==UserScript==
// @name Show Link Tooltips
// @match *
// @run-at document-start
// ==/UserScript==

var tooltip

function showTooltipFor (link) {
  if (tooltip) {
    tooltip.remove()
  }
  tooltip = document.createElement('div')
  tooltip.setAttribute('style', `
    position: fixed;
    bottom: 0;
    left: 0;
    background: #fff;
    border: 1px #ccc solid;
    border-top-right-radius: 3px;
    padding: 0.2em;
    font-family: sans-serif;
    font-weight: norma;
    font-size: 13px;
    pointer-events: none;
    white-space: nowrap;
    max-width: 400px;
    text-overflow: ellipsis;
    overflow: hidden;
    color: black;
    z-index: 2147483647;
    `)

  tooltip.textContent = link
  document.body.appendChild(tooltip)
}

document.body.addEventListener('mouseover', function (e) {
  var target = e.target
  while (target) {
    if (target.tagName === 'A') {
      showTooltipFor(target.href)
      tooltipTarget = target

      var func = function () {
        tooltip.remove()
        target.removeEventListener('mouseleave', func)
      }
      target.addEventListener('mouseleave', func)

      break
    }
    target = target.parentNode
  }
})
