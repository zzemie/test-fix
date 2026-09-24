import { readFileSync } from 'fs';
import { SourceTextModule } from 'vm';

const code = readFileSync(process.argv[2], 'utf8');
try {
  const m = new SourceTextModule(code);
  console.log('ESM SYNTAX OK');
} catch(e) {
  console.log('SYNTAX ERROR: ' + e.message);
  if (e.loc) console.log('  at line ' + e.loc.line + ' col ' + e.loc.column);
}
