<!--
SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>

SPDX-License-Identifier: MIT
-->

# Kernel Code Browser

A web-based Linux kernel source code browser powered by KDAB's codebrowser

[![checks][badge-shields-io-checks]][actions]
[![commit activity][badge-shields-io-commit-activity]][commits]
[![contributors][badge-shields-io-contributors]][contributors]
[![release date][badge-shields-io-release-date]][releases]
![commits since release][badge-shields-io-commits-since-release]
[![codecov][badge-shields-io-codecov]][codecov]

[badge-shields-io-checks]:
  https://img.shields.io/github/check-runs/black-desk/kernel-codebrowser/master

[actions]: https://github.com/black-desk/kernel-codebrowser/actions

[badge-shields-io-commit-activity]:
  https://img.shields.io/github/commit-activity/w/black-desk/kernel-codebrowser/master

[commits]: https://github.com/black-desk/kernel-codebrowser/commits/master

[badge-shields-io-contributors]:
  https://img.shields.io/github/contributors/black-desk/kernel-codebrowser

[contributors]: https://github.com/black-desk/kernel-codebrowser/graphs/contributors

[badge-shields-io-release-date]:
  https://img.shields.io/github/release-date/black-desk/kernel-codebrowser

[releases]: https://github.com/black-desk/kernel-codebrowser/releases

[badge-shields-io-commits-since-release]:
  https://img.shields.io/github/commits-since/black-desk/kernel-codebrowser/latest

[badge-shields-io-codecov]:
  https://codecov.io/github/black-desk/kernel-codebrowser/graph/badge.svg?token=6TSVGQ4L9X
[codecov]: https://codecov.io/github/black-desk/kernel-codebrowser

en | [zh_CN](README.zh_CN.md)

> [!WARNING]
>
> This English README is translated from the Chinese version using LLM and may
> contain errors.

[**codebrowser**](https://black-desk.github.io/kernel-codebrowser)

This project provides a web-based interface for browsing multiple versions of the Linux kernel source code. It uses [KDAB's codebrowser](https://github.com/KDAB/codebrowser) to generate searchable and navigable HTML representations of kernel source code, allowing developers and researchers to easily explore different kernel versions online.

## Development Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/black-desk/kernel-codebrowser.git
   cd kernel-codebrowser
   ```

2. Install dependencies (specific dependencies will be added as the project develops)

3. Configure kernel versions to browse (configuration details to be added)

4. Generate the code browser (build process to be defined)

5. Deploy the web interface (deployment instructions to be added)

## Project Status

⚠️ **This project is currently in early development phase**. The implementation details, build processes, and deployment instructions will be added as the project progresses.

## License

Unless otherwise specified, the code of this project are open source under the
GNU General Public License version 3 or any later version, while documentation,
configuration files, and scripts used in the development and maintenance process
are open source under the MIT License.

This project complies with the [REUSE specification].

You can use [reuse-tool](https://github.com/fsfe/reuse-tool) to generate the
SPDX list for this project:

```bash
reuse spdx
```

[REUSE specification]: https://reuse.software/spec-3.3/
