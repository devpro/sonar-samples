#!/usr/bin/env node

// Script to run Angular tests with legacy OpenSSL provider for Node.js 17+
const { spawn } = require('child_process');

const nodeVersion = process.version;
const majorVersion = parseInt(nodeVersion.slice(1).split('.')[0]);

// Set up environment
const env = { ...process.env, CI: 'true' };

// Add legacy provider for Node.js 17+
if (majorVersion >= 17) {
  env.NODE_OPTIONS = (env.NODE_OPTIONS || '') + ' --openssl-legacy-provider';
}

// Use npx to run ng, which handles cross-platform execution properly
const child = spawn('npx', [
  'ng',
  'test',
  '--code-coverage',
  '--watch=false',
  '--browsers=ChromeHeadlessCI'
], {
  stdio: 'inherit',
  env: env,
  shell: true
});

child.on('exit', (code) => {
  process.exit(code);
});