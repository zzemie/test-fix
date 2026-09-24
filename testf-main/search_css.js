const fs = require('fs');
const css = fs.readFileSync('C:\\Users\\jj\\Downloads\\classlist-main\\classlist-main\\assets\\index-D0mKrh8t-2bf6a912.css', 'utf8');

// Search for toolbar/header/top bar related CSS
const patterns = ['--toolbar', '--header', '--tab', '--bar', 'padding-top', 'grid-template', 'toolbar-h', 'header-h'];
for (const p of patterns) {
  let idx = 0;
  while ((idx = css.indexOf(p, idx)) !== -1) {
    console.log(`--- '${p}' at ${idx} ---`);
    console.log(css.substring(Math.max(0, idx - 60), idx + 120));
    console.log('');
    idx += p.length;
  }
}

// Also check the app class
const appIdx = css.indexOf('.app');
if (appIdx !== -1) {
  console.log("=== .app ===");
  console.log(css.substring(appIdx, appIdx + 300));
}
