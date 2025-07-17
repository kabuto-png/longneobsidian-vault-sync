# Contributing to Vault Sync Plugin

First off, thank you for considering contributing to the Vault Sync Plugin! 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Submitting Changes](#submitting-changes)
- [Bug Reports](#bug-reports)
- [Feature Requests](#feature-requests)
- [Style Guide](#style-guide)
- [Testing](#testing)

## 🤝 Code of Conduct

This project adheres to the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 🚀 Getting Started

### Prerequisites
- Node.js 16+ 
- npm or yarn
- Git
- Basic knowledge of TypeScript/JavaScript
- Familiarity with Obsidian plugins

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR-USERNAME/longneobsidian-vault-sync.git
   cd longneobsidian-vault-sync
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Build the Plugin**
   ```bash
   npm run build
   ```

4. **Development Mode**
   ```bash
   npm run dev  # Watch mode for automatic rebuilding
   ```

## 🔧 Making Changes

### Branch Naming
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `docs/description` - Documentation changes
- `refactor/description` - Code refactoring

### Commit Messages
Follow [Conventional Commits](https://conventionalcommits.org/):
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Testing changes
- `chore:` - Maintenance tasks

Examples:
```
feat: add status bar click functionality
fix: resolve auto-sync interval issues
docs: update README with new features
```

## 📤 Submitting Changes

1. **Create a Pull Request**
   - Fill out the PR template completely
   - Include screenshots for UI changes
   - Reference related issues

2. **PR Requirements**
   - ✅ Code builds successfully
   - ✅ Tests pass (if applicable)
   - ✅ Documentation updated
   - ✅ No breaking changes (or clearly documented)

3. **Review Process**
   - Maintainers will review your PR
   - Address feedback promptly
   - Keep PR focused and atomic

## 🐛 Bug Reports

### Before Submitting
- Search existing issues first
- Check if it's already fixed in latest version
- Try to reproduce consistently

### Bug Report Template
```markdown
**Bug Description**
Brief description of the issue

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g. macOS 14.5]
- Obsidian Version: [e.g. 1.6.5]
- Plugin Version: [e.g. 2.1.0]

**Additional Context**
Screenshots, logs, etc.
```

## 💡 Feature Requests

### Before Submitting
- Check existing feature requests
- Consider if it fits the plugin's scope
- Think about implementation complexity

### Feature Request Template
```markdown
**Feature Description**
Clear description of the requested feature

**Problem Statement**
What problem does this solve?

**Proposed Solution**
How should this work?

**Alternatives Considered**
Other approaches you've considered

**Additional Context**
Screenshots, mockups, examples
```

## 📝 Style Guide

### TypeScript/JavaScript
- Use TypeScript for all new code
- Follow existing code style
- Use meaningful variable names
- Add JSDoc comments for public methods

### Code Structure
```typescript
// Good
interface VaultSyncSettings {
    syncScript: string;
    autoSyncInterval: number;
    autoSyncEnabled: boolean;
}

// Bad
interface Settings {
    script: string;
    interval: number;
    enabled: boolean;
}
```

### File Organization
```
src/
├── main.ts           # Main plugin class
├── settings.ts       # Settings management
├── types.ts          # TypeScript interfaces
└── utils.ts          # Utility functions
```

## 🧪 Testing

### Manual Testing
1. Build the plugin
2. Copy to test vault: `.obsidian/plugins/vault-sync/`
3. Test all features:
   - Manual sync
   - Auto-sync
   - Settings changes
   - Status bar updates

### Test Checklist
- [ ] Plugin loads successfully
- [ ] Manual sync works
- [ ] Auto-sync toggles correctly
- [ ] Status bar updates
- [ ] Settings persist
- [ ] Error handling works
- [ ] Multiple vaults compatible

## 🔍 Code Review Guidelines

### For Contributors
- Keep changes focused and atomic
- Write descriptive commit messages
- Add comments for complex logic
- Update documentation as needed

### For Reviewers
- Be constructive and respectful
- Test the changes locally
- Check for breaking changes
- Verify documentation updates

## 🎯 Development Tips

### Plugin Development
- Use `npm run dev` for automatic rebuilding
- Enable Developer Tools in Obsidian
- Check console for errors and logs
- Test with different vault configurations

### Debugging
```typescript
console.log('Debug info:', variable);
console.error('Error occurred:', error);
```

### Performance
- Minimize file system operations
- Use async/await properly
- Avoid blocking the UI thread
- Monitor memory usage

## 📚 Resources

### Documentation
- [Obsidian Plugin API](https://github.com/obsidianmd/obsidian-api)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Git Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows)

### Tools
- [ESLint](https://eslint.org/) - Code linting
- [Prettier](https://prettier.io/) - Code formatting
- [esbuild](https://esbuild.github.io/) - Build tool

## 🎉 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in plugin documentation

## 📞 Questions?

- 💬 [GitHub Discussions](https://github.com/kabuto-png/longneobsidian-vault-sync/discussions)
- 🐛 [Issues](https://github.com/kabuto-png/longneobsidian-vault-sync/issues)
- 📧 [Email](mailto:kabuto.png@gmail.com)

---

Thank you for contributing to the Vault Sync Plugin! 🚀
