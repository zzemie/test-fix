const fs = require('fs');
const css = fs.readFileSync('C:\\Users\\jj\\Downloads\\classlist-main\\classlist-main\\assets\\index-D0mKrh8t-2bf6a912.css', 'utf8');

// Find .chrome CSS
const chromeIdx = css.indexOf('.chrome');
if (chromeIdx !== -1) {
  console.log("=== .chrome ===");
  console.log(css.substring(chromeIdx, chromeIdx + 500));
}

// Find the app's main content area
const mainIdx = css.indexOf('.main');
if (mainIdx !== -1) {
  console.log("\n=== .main ===");
  console.log(css.substring(mainIdx, mainIdx + 300));
}

// Find anything related to toolbar height
const thIdx = css.indexOf('--toolbar-h');
if (thIdx !== -1) {
  console.log("\n=== --toolbar-h ===");
  console.log(css.substring(Math.max(0, thIdx - 100), thIdx + 200));
}

// Find _dDyS6MQ class (fullscreen mode - hides topbar)
const fullscreenIdx = css.indexOf('._dDyS6MQ');
if (fullscreenIdx !== -1) {
  console.log("\n=== fullscreen class ===");
  console.log(css.substring(fullscreenIdx, fullscreenIdx + 200));
}
