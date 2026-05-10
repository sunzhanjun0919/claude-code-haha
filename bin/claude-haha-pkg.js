#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');

const rootDir = path.dirname(__dirname);
const entryFile = path.join(rootDir, 'src', 'entrypoints', 'cli.tsx');

const args = [entryFile, ...process.argv.slice(2)];

const isWin = process.platform === 'win32';
const cmd = isWin ? 'bun' : 'bun';

if (isWin) {
  const child = spawn(cmd, args, {
    cwd: rootDir,
    stdio: 'inherit',
    shell: true,
    windowsHide: true,
  });
  child.on('exit', (code) => process.exit(code || 0));
} else {
  const child = spawn(cmd, args, {
    cwd: rootDir,
    stdio: 'inherit',
  });
  child.on('exit', (code) => process.exit(code || 0));
}
