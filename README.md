# Claude Code 开发套件

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Changelog](https://img.shields.io/badge/changelog-v2.1.0-orange.svg)](CHANGELOG.md)

一个将 Claude Code 转变为编排式开发环境的集成系统，通过自动化文档管理、多代理工作流和外部 AI 专家系统实现。

## 🎯 为什么需要这个套件？

> *是否曾经尝试在 AI 协助下构建大型项目，却眼看着随着代码库增长，AI 开始力不从心？*

Claude Code 的输出质量直接取决于它对您项目的了解程度。随着 AI 辅助开发规模的扩大，出现了三个关键挑战：

---

### 挑战 1：上下文管理

**问题：**
```
❌ 无法跟踪架构模式和设计决策
❌ 忘记编码标准和团队约定
❌ 在大型代码库中找不到正确的上下文
```

**解决方案：**
✅ **自动化上下文交付**，通过两个集成系统实现：
- **三层文档系统** - 在正确的时间自动加载正确的文档
- **带子代理的自定义命令** - 编排已经了解您项目的专门代理
- 结果：无需手动加载上下文，所有代理保持一致的知识

---

### 挑战 2：AI 可靠性

**问题：**
```
❌ 过时的库文档
❌ 虚构的 API 方法
❌ 不一致的架构决策
```

**解决方案：**
✅ 通过 MCP 集成实现**"四眼原则"**：

| 服务 | 目的 | 益处 |
|---------|---------|---------|
| **Context7** | 实时库文档 | 当前 API，而非训练数据 |
| **Gemini** | 架构咨询 | 交叉验证和最佳实践 |

*结果：更少错误，更好的代码，符合当前标准*

---

### 挑战 3：无复杂性的自动化

**问题：**
```
❌ 每次会话都需要手动加载上下文
❌ 重复的命令序列
❌ 任务完成时没有反馈
```

**解决方案：**
✅ 通过钩子和命令实现**智能自动化**：
- 通过自定义命令自动更新文档
- 为所有子代理和 Gemini MCP 调用注入上下文
- 任务完成时的音频通知（可选）
- 复杂任务的一键式工作流

---

### 🎉 最终效果

> **Claude Code 从一个有用的工具转变为一个可靠的开发伙伴，能够记住您的项目上下文，验证自己的工作，并自动处理繁琐的任务。**


[![Demo-Video auf YouTube](https://img.youtube.com/vi/kChalBbMs4g/0.jpg)](https://youtu.be/kChalBbMs4g)



## 快速开始

### 前提条件

- **必需**：[Claude Code](https://github.com/anthropics/claude-code)
- **推荐**：MCP 服务器，如 [Context7](https://github.com/upstash/context7) 和 [Gemini Assistant](https://github.com/peterkrueck/mcp-gemini-assistant)

### 安装

#### 选项 1：快速安装（推荐）

在终端中运行以下命令：

```bash
curl -fsSL https://raw.githubusercontent.com/sabernagato/Claude-Code-Development-Kit/main/install.sh | bash
```

这将：
1. 下载框架
2. 引导您完成交互式设置
3. 在您选择的项目目录中安装所有内容
4. 提供可选 MCP 服务器安装的链接


https://github.com/user-attachments/assets/0b4a1e69-bddb-4b58-8de9-35f97919bf44


#### 选项 2：克隆并安装

```bash
git clone https://github.com/peterkrueck/Claude-Code-Development-Kit.git
cd Claude-Code-Development-Kit
./setup.sh
```

### 安装内容

设置脚本将在您的项目中创建以下结构：

```
your-project/
├── commands/              # AI 编排模板（.md 文件）
├── hooks/                 # 自动化脚本
│   ├── config/            # 安全模式配置
│   ├── sounds/            # 通知声音（如果启用通知）
│   └── *.sh               # 钩子脚本（基于您的选择）
├── docs/                  # 文档模板和示例
│   ├── ai-context/        # 核心文档文件
│   ├── open-issues/       # 问题跟踪示例
│   └── specs/             # 规范模板
├── logs/                  # 钩子执行日志（运行时创建）
├── .claude/               
│   └── settings.local.json # 生成的 Claude Code 配置
├── CLAUDE.md              # 您项目的 AI 上下文（从模板）
└── MCP-ASSISTANT-RULES.md # MCP 编码标准（如果选择了 Gemini-Assistant-MCP）
```

**注意**：具体安装的文件取决于您在设置过程中的选择（MCP 服务器、通知等）。

### 安装后设置

1. **自定义您的 AI 上下文**：
   - 使用您的项目标准编辑 `CLAUDE.md`
   - 使用您的技术栈更新 `docs/ai-context/project-structure.md`

2. **安装 MCP 服务器**（如果在设置期间选择）：
   - 按照安装程序提供的链接操作
   - 在 `.claude/settings.local.json` 中配置

3. **测试您的安装**：
   ```bash
   claude
   /full-context "分析我的项目结构"
   ```


## 术语表

- **CLAUDE.md** - 包含项目特定 AI 指令、编码标准和集成模式的主上下文文件
- **CONTEXT.md** - 组件和功能级文档文件（第 2 层和第 3 层），提供具体的实现细节和模式
- **MCP（模型上下文协议）** - 将外部 AI 服务与 Claude Code 集成的标准
- **子代理（Sub-agents）** - Claude Code 生成的专门 AI 代理，并行处理任务的特定方面
- **三层文档** - 分层组织（基础/组件/功能），最小化维护同时最大化 AI 效率
- **自动加载** - 命令执行时自动包含相关文档
- **钩子（Hooks）** - 在 Claude Code 生命周期的特定点执行的 Shell 脚本，用于安全、自动化和用户体验增强

## 架构

### 集成智能循环

```
                        CLAUDE CODE
                   ┌─────────────────┐
                   │                 │
                   │    COMMANDS      │
                   │                 │
                   └────────┬────────┘
                  多代理编排│
                   并行执行│
                   动态扩展│
                           ╱│╲
                          ╱ │ ╲
          路由代理到     ╱  │  ╲  利用
          正确文档      ╱   │   ╲ 专家知识
                       ╱    │    ╲
                      ▼     │     ▼
         ┌─────────────────┐│┌─────────────────┐
         │                 │││                 │
         │  DOCUMENTATION  │││  MCP SERVERS   │
         │                 │││                 │
         └─────────────────┘│└─────────────────┘
          三层结构           │  Context7 + Gemini
          自动加载           │  实时更新
          上下文路由         │  AI 咨询
                      ╲     │     ╱
                       ╲    │    ╱
        为咨询提供       ╲   │   ╱ 增强当前
        项目上下文        ╲  │  ╱  最佳实践
                           ╲│╱
                            ▼
                    集成工作流
```

### 自动加载机制

每次命令执行都会自动加载关键文档：

```
@/CLAUDE.md                              # 主 AI 上下文和编码标准
@/docs/ai-context/project-structure.md   # 完整的技术栈和文件树
@/docs/ai-context/docs-overview.md       # 文档路由图
```

`subagent-context-injector.sh` 钩子将自动加载扩展到所有子代理：
- 通过 Task 工具生成的子代理自动接收相同的核心文档
- Task 提示中无需手动包含上下文
- 确保多代理工作流中所有代理的知识一致

这确保了：
- 所有会话和子代理中 AI 行为的一致性
- 任何级别都无需手动管理上下文

### 组件集成

**命令 ↔️ 文档**
- 命令根据任务复杂度决定加载哪些文档层
- 文档结构指导代理生成模式
- 命令更新文档以保持当前上下文

**命令 ↔️ MCP 服务器**
- Context7 提供最新的库文档
- Gemini 为复杂问题提供架构咨询
- 集成在命令工作流中无缝进行

**文档 ↔️ MCP 服务器**
- 项目结构和 MCP 助手规则自动附加到 Gemini 咨询
- 确保外部 AI 理解特定架构和编码标准
- 使所有建议与项目相关并符合标准

### 钩子集成

套件包含经过实战检验的钩子，增强 Claude Code 的能力：

- **安全扫描器** - 防止在使用 MCP 服务器时意外暴露秘密
- **Gemini 上下文注入器** - 自动在 Gemini 咨询中包含项目结构
- **子代理上下文注入器** - 确保所有子代理自动接收核心文档
- **通知系统** - 为任务完成和输入请求提供非阻塞音频反馈（可选）

这些钩子与命令和 MCP 服务器工作流无缝集成，提供：
- 所有外部 AI 调用的预执行安全检查
- 外部 AI 和子代理的自动上下文增强
- 多代理工作流中所有代理的知识一致性
- 通过愉悦的非阻塞音频通知提高开发者感知

## 常见任务

### 开始新功能开发

```bash
/full-context "在后端和前端实现用户认证"
```

系统将：
1. 自动加载项目文档
2. 生成专门的代理（安全、后端、前端）
3. 咨询 Context7 获取认证框架文档
4. 向 Gemini 2.5 pro 征求反馈和改进建议
4. 提供全面的分析和实施计划

### 多视角代码审查

```bash
/code-review "审查认证实现"
```

多个代理分析：
- 安全漏洞
- 性能影响
- 架构对齐
- 集成影响

### 保持文档最新

```bash
/update-docs "记录认证更改"
```

自动：
- 更新所有层级的受影响 CLAUDE.md 文件
- 保持 project-structure.md 和 docs-overview.md 最新
- 为未来的 AI 会话维护上下文
- 确保文档与实现匹配

## 创建您的项目结构

安装后，您将添加项目特定的文档：

```
your-project/
├── .claude/
│   ├── commands/              # AI 编排模板
│   ├── hooks/                 # 安全和自动化钩子
│   │   ├── config/            # 钩子配置文件
│   │   ├── sounds/            # 通知音频文件
│   │   ├── gemini-context-injector.sh
│   │   ├── mcp-security-scan.sh
│   │   ├── notify.sh
│   │   └── subagent-context-injector.sh
│   └── settings.json          # Claude Code 配置
├── docs/
│   ├── ai-context/            # 基础文档（第 1 层）
│   │   ├── docs-overview.md   # 文档路由图
│   │   ├── project-structure.md # 技术栈和文件树
│   │   ├── system-integration.md # 跨组件模式
│   │   ├── deployment-infrastructure.md # 基础设施上下文
│   │   └── handoff.md        # 会话连续性
│   ├── open-issues/           # 问题跟踪模板
│   ├── specs/                 # 功能规范
│   └── README.md              # 文档系统指南
├── CLAUDE.md                  # 主 AI 上下文（第 1 层）
├── backend/
│   └── CONTEXT.md              # 后端上下文（第 2 层）- 创建此文件
└── backend/src/api/
    └── CONTEXT.md              # API 上下文（第 3 层）- 创建此文件
```

框架在 `docs/` 中提供 CONTEXT.md 文件模板：
- `docs/CONTEXT-tier2-component.md` - 用作组件级文档模板
- `docs/CONTEXT-tier3-feature.md` - 用作功能级文档模板

## 配置

套件设计用于适配：

- **命令** - 在 `.claude/commands/` 中修改编排模式
- **文档** - 根据您的架构调整层级结构
- **MCP 集成** - 添加额外的服务器以获得专门的专业知识
- **钩子** - 在 `.claude/hooks/` 中自定义安全模式、添加新钩子或修改通知
- **MCP 助手规则** - 将 `docs/MCP-ASSISTANT-RULES.md` 模板复制到项目根目录并为项目特定标准进行自定义

## 最佳实践

1. **让文档指导开发** - 三层结构反映自然边界
2. **立即更新文档** - 重大更改后使用 `/update-docs`
3. **信任自动加载** - 避免手动上下文管理
4. **自然扩展复杂性** - 简单任务保持简单，复杂任务获得复杂分析


## 文档

- [文档系统指南](docs/) - 理解三层架构
- [命令参考](commands/) - 详细的命令使用
- [MCP 集成](docs/CLAUDE.md) - 配置外部服务
- [钩子系统](hooks/) - 安全扫描、上下文注入和通知
- [更新日志](CHANGELOG.md) - 版本历史和迁移指南

## 贡献

该套件代表了 AI 辅助开发的一种方法。欢迎贡献和改编。

## 联系

如果您有疑问、需要澄清或希望提供反馈，请随时在 [LinkedIn](https://www.linkedin.com/in/peterkrueck/) 上与我联系。