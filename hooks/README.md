# Claude Code 钩子

本目录包含经过实战检验的钩子，通过自动安全扫描、智能上下文注入和愉快的音频反馈来增强您的 Claude Code 开发体验。

## 架构

```
Claude Code Lifecycle
        │
        ├── PreToolUse ──────► Security Scanner
        │                      ├── Context Injector (Gemini)
        │                      └── Context Injector (Subagents)
        │
        ├── Tool Execution
        │
        ├── PostToolUse
        │
        ├── Notification ────────► Audio Feedback
        │
        └── Stop/SubagentStop ───► Completion Sound
```

这些钩子在 Claude Code 生命周期的特定时间点执行，为 AI 行为提供确定性控制。

## 可用钩子

### 1. Gemini 上下文注入器 (`gemini-context-injector.sh`)

**用途**：在启动新的 Gemini 咨询会话时自动包含您的项目文档和助手规则，确保 AI 拥有关于您的代码库和项目标准的完整上下文。

**触发器**：`mcp__gemini__consult_gemini` 的 `PreToolUse`

**功能**：
- 检测新的 Gemini 咨询会话（无 session_id）
- 自动附加两个关键文件：
  - `docs/ai-context/project-structure.md` - 完整的项目结构和技术栈
  - `MCP-ASSISTANT-RULES.md` - 项目特定的编码标准和指南
- 保留现有的文件附件
- 会话感知（仅在新会话时注入）
- 记录所有注入事件以便调试
- 如果任一文件缺失则优雅失败
- 处理部分可用性（将附加存在的文件）

**自定义**：
- 将 `docs/MCP-ASSISTANT-RULES.md` 模板复制到您的项目根目录
- 使用您的项目特定标准、原则和约束进行自定义
- 钩子将自动在 Gemini 咨询中包含它

### 2. MCP 安全扫描器 (`mcp-security-scan.sh`)

**用途**：在使用 Gemini 或 Context7 等 MCP 服务器时，防止意外暴露秘密、API 密钥和敏感数据。

**触发器**：所有 MCP 工具 (`mcp__.*`) 的 `PreToolUse`

**功能**：
- 基于模式的 API 密钥、密码和秘密检测
- 扫描代码上下文、问题描述和附加文件
- 带大小限制的文件内容扫描
- 通过 `config/sensitive-patterns.json` 配置模式匹配
- 占位符值的白名单
- Context7 的命令注入保护
- 将安全事件全面记录到 `.claude/logs/`

**自定义**：编辑 `config/sensitive-patterns.json` 以：
- 添加自定义 API 密钥模式
- 修改凭据检测规则
- 更新敏感文件模式
- 为您的占位符扩展白名单

### 3. 子代理上下文注入器 (`subagent-context-injector.sh`)

**用途**：在所有子代理 Task 提示中自动包含核心项目文档，确保多代理工作流中的上下文一致性。

**触发器**：`Task` 工具的 `PreToolUse`

**功能**：
- 在执行前拦截所有 Task 工具调用
- 在前面添加对三个核心文档文件的引用：
  - `docs/CLAUDE.md` - 项目概述、编码标准、AI 指令
  - `docs/ai-context/project-structure.md` - 完整的文件树和技术栈
  - `docs/ai-context/docs-overview.md` - 文档架构
- 保持非 Task 工具不变通过
- 通过在前面添加上下文来保留原始任务提示
- 在所有子代理中启用一致的知识
- 消除在 Task 提示中手动包含上下文的需要

**好处**：
- 每个子代理都从相同的基础知识开始
- 每个 Task 提示中不需要手动指定上下文
- 通过 @ 引用而不是内容复制来节省令牌
- 在一个地方更新上下文，影响所有子代理
- 通过简单的非 Task 工具通过来保持操作清洁

### 4. 通知系统 (`notify.sh`)

**用途**：当 Claude Code 需要您的注意或完成任务时，提供愉快的音频反馈。

**触发器**：
- `Notification` 事件（所有通知，包括需要输入）
- `Stop` 事件（主任务完成）

**功能**：
- 跨平台音频支持（macOS、Linux、Windows）
- 非阻塞音频播放（在后台运行）
- 多个音频播放回退
- 愉快的通知声音
- 两种通知类型：
  - `input`：当 Claude 需要用户输入时
  - `complete`：当 Claude 完成任务时

## 安装

1. **将钩子复制到您的项目**：
   ```bash
   cp -r hooks your-project/.claude/
   ```

2. **在您的项目中配置钩子**：
   ```bash
   cp hooks/setup/settings.json.template your-project/.claude/settings.json
   ```
   然后编辑设置文件中的 WORKSPACE 路径。

3. **测试钩子**：
   ```bash
   # 测试通知
   .claude/hooks/notify.sh input
   .claude/hooks/notify.sh complete
   
   # 查看日志
   tail -f .claude/logs/context-injection.log
   tail -f .claude/logs/security-scan.log
   ```

## 钩子配置

添加到您的 Claude Code `settings.json`：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__gemini__consult_gemini",
        "hooks": [
          {
            "type": "command",
            "command": "${WORKSPACE}/.claude/hooks/gemini-context-injector.sh"
          }
        ]
      },
      {
        "matcher": "mcp__.*",
        "hooks": [
          {
            "type": "command",
            "command": "${WORKSPACE}/.claude/hooks/mcp-security-scan.sh"
          }
        ]
      },
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "${WORKSPACE}/.claude/hooks/subagent-context-injector.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "${WORKSPACE}/.claude/hooks/notify.sh input"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "${WORKSPACE}/.claude/hooks/notify.sh complete"
          }
        ]
      }
    ]
  }
}
```

请参阅 `hooks/setup/settings.json.template` 以获取包含所有钩子和 MCP 服务器的完整配置。

## 安全模型

1. **执行上下文**：钩子以完整的用户权限运行
2. **阻塞行为**：退出代码 2 阻止工具执行
3. **数据流**：钩子可以通过 JSON 转换修改工具输入
4. **隔离**：每个钩子在其自己的进程中运行
5. **日志**：所有安全事件都记录到 `.claude/logs/`

## 与 MCP 服务器集成

钩子系统补充了 MCP 服务器集成：

- **Gemini 咨询**：上下文注入器确保包含项目结构和 MCP 助手规则
- **Context7 文档**：安全扫描器保护库 ID 输入
- **所有 MCP 工具**：在外部调用前进行通用安全扫描

## 最佳实践

1. **钩子设计**：
   - 优雅失败 - 永远不要破坏主工作流
   - 记录重要事件以便调试
   - 适当使用退出代码（0=成功，2=阻塞）
   - 保持执行时间最小

2. **安全**：
   - 定期更新敏感模式
   - 定期审查安全日志
   - 先在安全环境中测试钩子
   - 永远不要在钩子中记录敏感数据

3. **配置**：
   - 使用 `${WORKSPACE}` 变量以便移植
   - 保持钩子可执行（`chmod +x`）
   - 版本控制钩子配置
   - 记录自定义修改

## 故障排除

### 钩子未执行
- 检查文件权限：`chmod +x *.sh`
- 验证 settings.json 中的路径
- 检查 Claude Code 日志以查看错误

### 安全扫描器过于严格
- 审查 `config/sensitive-patterns.json` 中的模式
- 将合法模式添加到白名单
- 检查日志以了解触发阻塞的内容

### 没有声音播放
- 验证 `sounds/` 目录中存在声音文件
- 测试音频播放：`.claude/hooks/notify.sh input`
- 检查系统音频设置
- 确保您安装了音频播放器（afplay、paplay、aplay、pw-play、play、ffplay 或 Windows 上的 PowerShell）

## 钩子设置命令

对于全面的设置验证和测试，请使用：

```
/hook-setup
```

此命令使用多代理编排来验证安装、检查配置并运行全面测试。详情请参阅 [hook-setup.md](setup/hook-setup.md)。

## 扩展点

该套件专为可扩展性而设计：

1. **自定义钩子**：按照现有模式添加新脚本
2. **事件处理程序**：为任何 Claude Code 事件配置钩子
3. **模式更新**：根据您的需要修改安全模式
4. **声音自定义**：用您的偏好替换音频文件