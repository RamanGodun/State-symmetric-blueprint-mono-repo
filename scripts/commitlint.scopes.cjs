const fs = require('fs');
const path = require('path');

const DEFAULT_ROOTS = ['packages', 'apps'];
const IGNORE_DIRS = new Set([
  '.git', '.husky', '.dart_tool', 'node_modules', 'build', 'coverage',
  'test_cache', '.idea', '.vscode', 'ios', 'android'
]);

function listDirs(root, baseDir) {
  const abs = path.resolve(baseDir, root);
  if (!fs.existsSync(abs)) return [];
  try {
    return fs
      .readdirSync(abs, { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .map((d) => d.name)
      .filter((name) => !name.startsWith('.') && !IGNORE_DIRS.has(name));
  } catch {
    return [];
  }
}

function getRoots() {
  const env = process.env.COMMIT_SCOPE_ROOTS;
  if (!env) return DEFAULT_ROOTS;
  return env.split(',').map((s) => s.trim()).filter(Boolean);
}

function getScopes(roots = DEFAULT_ROOTS, extra = [], baseDir = process.cwd()) {
  const fromRoots = roots.flatMap((r) => listDirs(r, baseDir));
  return Array.from(new Set([...fromRoots, ...extra])).sort();
}

// Глобальні скоупи для робіт на рівні репозиторію:
const defaultExtra = ['repo', 'workflows', 'ci', 'release', 'docs', 'tooling'];

// Додаткові скоупи через ENV: COMMIT_SCOPES="infra,security"
const envExtra = process.env.COMMIT_SCOPES
  ? process.env.COMMIT_SCOPES.split(',').map((s) => s.trim()).filter(Boolean)
  : [];

// База для резолву шляхів: директорія, де лежить цей файл (стабільно в CI)
const BASE_DIR = path.dirname(__filename);

module.exports.scopes = getScopes(getRoots(), [...defaultExtra, ...envExtra], BASE_DIR);
// Result example: ['app_on_cubit','app_on_riverpod','assets','core','app_bootstrap']
