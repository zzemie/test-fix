import { readFileSync } from 'fs';
import { parse } from 'node:url';

const code = readFileSync(new URL('./classlist-main/assets/index-Dg4BjOqn-2bf6a912.js', import.meta.url), 'utf8');

try {
  new Function(code);
  console.log('CJS SYNTAX OK');
} catch(e) {
  if (e.message.includes('import')) {
    // It's an ESM file, try a different check
    // Just check bracket balance
    let depth = 0;
    let parens = 0;
    let braces = 0;
    let brackets = 0;
    let inString = false;
    let stringChar = '';
    let escaped = false;
    for (let i = 0; i < code.length; i++) {
      const ch = code[i];
      if (escaped) { escaped = false; continue; }
      if (ch === '\\') { escaped = true; continue; }
      if (inString) {
        if (ch === stringChar) inString = false;
        continue;
      }
      if (ch === '"' || ch === "'" || ch === '`') { inString = true; stringChar = ch; continue; }
      if (ch === '(') parens++;
      if (ch === ')') parens--;
      if (ch === '{') braces++;
      if (ch === '}') braces--;
      if (ch === '[') brackets++;
      if (ch === ']') brackets--;
    }
    console.log(`Bracket balance - parens: ${parens}, braces: ${braces}, brackets: ${brackets}`);
    if (parens === 0 && braces === 0 && brackets === 0) {
      console.log('BRACKET BALANCE OK');
    } else {
      console.log('BRACKET BALANCE WRONG');
    }
  }
}
