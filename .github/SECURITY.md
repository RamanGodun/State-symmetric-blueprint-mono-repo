# Security Policy

## Supported Versions

This is a demonstration monorepo showcasing state-symmetric architecture patterns for Flutter applications. While this is primarily an educational project, we take security seriously.

| Version | Supported          |
| ------- | ------------------ |
| main    | :white_check_mark: |
| other   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

### 🔒 Private Disclosure

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, please report security issues privately:

1. **GitHub Security Advisory** (preferred)
   - Go to the [Security tab](../../security/advisories)
   - Click "Report a vulnerability"
   - Provide detailed information about the vulnerability

2. **Email Contact**
   - Email: [Your security contact email]
   - Subject: `[SECURITY] Brief description`
   - Include:
     - Description of the vulnerability
     - Steps to reproduce
     - Potential impact
     - Suggested fix (if any)

### 📋 What to Include

A good security report includes:

- **Description**: Clear explanation of the vulnerability
- **Impact**: What could an attacker do?
- **Reproduction**: Step-by-step instructions
- **Environment**:
  - Flutter version
  - Dart version
  - Platform (iOS/Android/Web)
  - Affected packages in the monorepo
- **Suggested Fix**: If you have ideas (optional)

### ⏱️ Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: 7 days
  - High: 30 days
  - Medium: 90 days
  - Low: Best effort

### 🎯 Scope

#### In Scope

- Authentication and authorization issues
- Data exposure vulnerabilities
- Dependency vulnerabilities
- Code injection vulnerabilities
- Cross-site scripting (XSS) in web builds
- Path traversal issues

#### Out of Scope

- Issues in third-party dependencies (report to the maintainer)
- Issues already publicly disclosed
- Social engineering attacks
- Physical attacks
- Denial of Service (DoS) attacks

### 🏆 Recognition

We appreciate responsible disclosure! Contributors who report valid security issues will be:

- Credited in the security advisory (if desired)
- Listed in a security acknowledgments section
- Given priority consideration for pull requests

### 📜 Security Best Practices

When contributing to this project:

1. **Never commit secrets**
   - Use `.env` files (gitignored)
   - Use environment variables
   - Use secrets management tools

2. **Keep dependencies updated**
   - Monitor Dependabot alerts
   - Regular dependency audits
   - Use `dart pub outdated`

3. **Follow secure coding practices**
   - Input validation
   - Output encoding
   - Proper error handling
   - Secure data storage

4. **Review before merge**
   - All PRs require review
   - Run security linters
   - Check for sensitive data

## 📚 Additional Resources

- [OWASP Mobile Security Project](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [Dart Security Guidelines](https://dart.dev/guides/libraries/secure-programming)

## 🤝 Thanks

Thank you for helping keep this project and the Flutter community secure!

---

_Last updated: January 2026_
