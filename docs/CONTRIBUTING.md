# CONTRIBUTING.md

> **Status:** Draft  
> **Purpose:** Guide contributors on how to participate in the edible project.

---

## Document Purpose

This document defines how to contribute code, documentation, and ideas to edible. It establishes standards for pull requests, code review, commit conventions, and community expectations.

## Contents *(to be expanded)*

### 1. Getting Started
1. Fork the repository
2. Clone your fork: `git clone https://github.com/<you>/Food-Logging-Platform.git`
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Read the relevant docs in `docs/` before coding
5. Make changes and open a PR

### 2. Branch Naming
| Prefix | Use |
|--------|-----|
| `feature/` | New functionality |
| `fix/` | Bug fixes |
| `docs/` | Documentation only |
| `refactor/` | Code restructuring, no behavior change |
| `chore/` | Tooling, CI, dependencies |

### 3. Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(backend): add health profile endpoint
fix(ai): handle low-confidence food recognition
docs: update API.md with recommendation schema
```

### 4. Pull Request Guidelines
- Keep PRs small and focused — one concern per PR
- Include a clear description of *what* and *why*
- Link related issues
- Update documentation if behavior changes
- Ensure CI passes before requesting review

### 5. Code Standards *(to be finalized with stack)*
- Linting and formatting enforced via CI
- No secrets or credentials in code
- Health recommendation logic must have unit tests
- API changes require updates to `docs/API.md`

### 6. Documentation Changes
- Product/design changes → update `docs/PRODUCT.md`
- Architecture changes → update `docs/ARCHITECTURE.md` and `docs/SYSTEM_DESIGN.md`
- New endpoints → update `docs/API.md`
- Schema changes → update `docs/DATABASE.md` and add migration

### 7. Review Process
- At least one approval required before merge
- Address all review comments or explain why not
- Squash merge to `main` for clean history

### 8. Reporting Issues
- Use GitHub Issues with provided templates
- Include steps to reproduce for bugs
- Label appropriately: `bug`, `enhancement`, `documentation`

### 9. Code of Conduct
- Be respectful and constructive
- Welcome contributors of all experience levels
- Focus on the code and design, not the person

## Related Documents

- [README.md](../README.md) — project overview
- [docs/README.md](./README.md) — documentation index
