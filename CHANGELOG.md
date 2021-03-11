# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0]
### Added
- Initial implementation
- Introduce paramter for confiugring the Prometheus name ([#11])
- Add alert for slow backup jobs ([#19])

### Changed

- Conditional import of Crossplane lib ([#2])
- Allow restic alert filter to be null ([#6])
- Switch docker registry from docker.io to quay.io ([#14])
- Option to disable the component
- Move alert definitions to parameters ([#18])
- Adjust K8upJobStuck alert configuration ([#10])

[Unreleased]: https://github.com/projectsyn/component-backup-k8up/compare/v1.0.0...HEAD
[v1.0.0]: https://github.com/projectsyn/component-backup-k8up/releases/tag/v1.0.0

[#2]: https://github.com/projectsyn/component-backup-k8up/pull/2
[#6]: https://github.com/projectsyn/component-backup-k8up/pull/6
[#10]: https://github.com/projectsyn/component-backup-k8up/pull/10
[#11]: https://github.com/projectsyn/component-backup-k8up/pull/11
[#14]: https://github.com/projectsyn/component-backup-k8up/pull/14
[#18]: https://github.com/projectsyn/component-backup-k8up/pull/18
[#19]: https://github.com/projectsyn/component-backup-k8up/pull/19
