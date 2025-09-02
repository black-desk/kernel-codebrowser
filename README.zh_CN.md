<!--
SPDX-FileCopyrightText: 2025 Chen Linxuan <me@black-desk.cn>

SPDX-License-Identifier: MIT
-->

# Kernel Code Browser

基于 KDAB 的 codebrowser 构建的 Linux 内核源代码在线浏览器

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

[en](README.md) | zh_CN

[**codebrowser**](https://black-desk.github.io/kernel-codebrowser)

该项目提供一个基于 Web 的界面，用于浏览多个版本的 Linux 内核源代码。它使用 [KDAB 的 codebrowser](https://github.com/KDAB/codebrowser) 来生成可搜索和可导航的内核源代码 HTML 表示，使开发者和研究人员能够轻松地在线探索不同的内核版本。

## 使用

## 开发环境搭建

1. 克隆仓库：

   ```bash
   git clone https://github.com/black-desk/kernel-codebrowser.git
   cd kernel-codebrowser
   ```

2. 安装依赖（具体依赖项将随项目发展而添加）

3. 配置要浏览的内核版本（配置详情待添加）

4. 生成代码浏览器（构建过程待定义）

5. 部署 Web 界面（部署说明待添加）

## 项目状态

⚠️ **该项目目前处于早期开发阶段**。实现细节、构建过程和部署说明将随着项目进展逐步添加。

## 许可证

如无特殊说明，该项目的代码以GNU通用公共许可协议第三版或任何更新的版本开源，文档、配置文件以及开发维护过程中使用的脚本等以MIT许可证开源。

该项目遵守[REUSE规范]。

你可以使用[reuse-tool](https://github.com/fsfe/reuse-tool)生成这个项目的SPDX列表：

```bash
reuse spdx
```

[REUSE规范]: https://reuse.software/spec-3.3/
