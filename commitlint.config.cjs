/** @type {import('@commitlint/types').UserConfig} */
const { scopes } = require('./scripts/commitlint.scopes.cjs');

module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'perf', 'refactor', 'docs', 'test', 'build', 'ci', 'chore', 'style'
    ]],
    'scope-enum': [2, 'always', scopes],
    'subject-empty': [2, 'never'],
    'header-max-length': [2, 'always', 100]
  }
};
