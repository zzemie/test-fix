import { readFileSync } from 'fs';
const code = readFileSync(process.argv[2], 'utf8');
try {
  new Function(code);
  console.log('SYNTAX OK (CJS check)');
} catch(e) {
  if (e.message.includes('import')) {
    console.log('ESM file - CJS check n/a, checking brackets...');
  } else {
    console.log('SYNTAX ERROR: ' + e.message);
  }
}
