const { spawn, execSync } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

const rootDir = path.join(__dirname, '..');

function findBun() {
    const candidates = [
        'bun',
        path.join(process.env.USERPROFILE || '', '.bun', 'bin', 'bun.exe'),
        path.join(os.homedir(), '.bun', 'bin', 'bun.exe'),
        'C:\\Program Files\\bun\\bin\\bun.exe',
    ];

    for (const candidate of candidates) {
        try {
            if (candidate === 'bun') {
                execSync('bun --version', { stdio: 'ignore' });
            } else if (fs.existsSync(candidate)) {
                execSync(`"${candidate}" --version`, { stdio: 'ignore' });
            }
            return candidate;
        } catch {}
    }
    return null;
}

function installBun() {
    console.log('\n==========================================');
    console.log('  Claude Code - Windows Installer');
    console.log('==========================================\n');
    console.log('Bun is required but not found.');
    console.log('Installing Bun...\n');

    try {
        execSync('powershell -ExecutionPolicy Bypass -Command "irm bun.sh/install.ps1 | iex"', {
            stdio: 'inherit',
            cwd: rootDir
        });
        return findBun();
    } catch (error) {
        console.error('\n[ERROR] Failed to install Bun automatically.');
        console.error('Please install Bun manually: https://bun.sh\n');
        console.error('On Windows, run in PowerShell (Admin):');
        console.error('  irm bun.sh/install.ps1 | iex\n');
        process.exit(1);
    }
}

function main() {
    const bunPath = findBun() || installBun();

    if (!bunPath) {
        console.error('[ERROR] Could not find or install Bun');
        process.exit(1);
    }

    const args = process.argv.slice(2);
    const entryFile = path.join(rootDir, 'src', 'entrypoints', 'cli.tsx');
    const envFile = path.join(rootDir, '.env');

    const env = { ...process.env };
    if (fs.existsSync(envFile)) {
        try {
            const envContent = fs.readFileSync(envFile, 'utf8');
            envContent.split('\n').forEach(line => {
                const match = line.match(/^([^=]+)=(.*)$/);
                if (match) {
                    env[match[1].trim()] = match[2].trim();
                }
            });
        } catch {}
    }

    const bunArgs = [
        '--env-file=.env',
        entryFile,
        ...args
    ];

    const child = spawn(bunPath, bunArgs, {
        cwd: rootDir,
        stdio: 'inherit',
        env,
        shell: false,
        windowsHide: false
    });

    child.on('exit', (code) => {
        process.exit(code || 0);
    });

    child.on('error', (error) => {
        console.error('[ERROR]', error.message);
        process.exit(1);
    });
}

main();
