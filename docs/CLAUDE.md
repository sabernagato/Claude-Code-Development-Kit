# [项目名称] - AI 上下文模板 (claude-master)

## 1. 项目概述
- **愿景：** [描述您项目的愿景和目标]
- **当前阶段：** [当前开发阶段和状态]
- **关键架构：** [高层架构描述]
- **开发策略：** [开发方法和策略说明]

## 2. 项目结构

**⚠️ 关键提示：AI 代理在尝试任何任务之前必须阅读[项目结构文档](/docs/ai-context/project-structure.md)，以了解完整的技术栈、文件树和项目组织。**

[项目名称] 遵循 [描述架构模式]。有关完整的技术栈和文件树结构，请参阅 [docs/ai-context/project-structure.md](/docs/ai-context/project-structure.md)。

## 3. 编码标准和 AI 指令

### 通用指令
- 您最重要的工作是管理自己的上下文。在计划更改之前，始终阅读任何相关文件。
- 更新文档时，保持更新简洁和切中要点，以防止膨胀。
- 遵循 KISS、YAGNI 和 DRY 原则编写代码。
- 有疑问时，遵循经过验证的实现最佳实践。
- 未经用户批准，不要提交到 git。
- 不要运行任何服务器，而是告诉用户运行服务器进行测试。
- 始终优先考虑行业标准库/框架，而不是自定义实现。
- 永远不要模拟任何东西。永远不要使用占位符。永远不要省略代码。
- 在相关的地方应用 SOLID 原则。使用现代框架特性，而不是重新发明解决方案。
- 对一个想法的好坏要坦率诚实。
- 使副作用明确且最小化。
- 设计数据库模式以便于演进（避免破坏性更改）。


### 文件组织和模块化
- 默认创建多个小而专注的文件，而不是大型整体文件
- 每个文件应该有单一的职责和明确的目的
- 尽可能将文件保持在 350 行以下 - 通过将实用程序、常量、类型或逻辑组件提取到单独的模块中来拆分较大的文件
- 分离关注点：将实用程序、常量、类型、组件和业务逻辑放在不同的文件中
- 优先使用组合而不是继承 - 仅对真正的"是一个"关系使用继承，对"有一个"或行为混合使用组合

- 遵循现有的项目结构和约定 - 将文件放在适当的目录中。如果认为合适，创建新目录并移动文件。
- 使用定义良好的子目录来保持组织和可扩展性
- 使用清晰的文件夹层次结构和一致的命名约定来构建项目
- 正确导入/导出 - 为可重用性和可维护性进行设计

### 类型提示（必需）
- **始终**为函数参数和返回值使用类型提示
- 对复杂类型使用 `from typing import`
- 优先使用 `Optional[T]` 而不是 `Union[T, None]`
- 对数据结构使用 Pydantic 模型

```python
# 良好示例
from typing import Optional, List, Dict, Tuple

async def process_audio(
    audio_data: bytes,
    session_id: str,
    language: Optional[str] = None
) -> Tuple[bytes, Dict[str, Any]]:
    """通过管道处理音频。"""
    pass
```

### 命名约定
- **类**：PascalCase（例如，`VoicePipeline`）
- **函数/方法**：snake_case（例如，`process_audio`）
- **常量**：UPPER_SNAKE_CASE（例如，`MAX_AUDIO_SIZE`）
- **私有方法**：前导下划线（例如，`_validate_input`）
- **Pydantic 模型**：带 `Schema` 后缀的 PascalCase（例如，`ChatRequestSchema`、`UserSchema`）


### 文档要求
- 每个模块都需要文档字符串
- 每个公共函数都需要文档字符串
- 使用 Google 风格的文档字符串
- 在文档字符串中包含类型信息

```python
def calculate_similarity(text1: str, text2: str) -> float:
    """计算两个文本之间的语义相似度。

    Args:
        text1: 要比较的第一个文本
        text2: 要比较的第二个文本

    Returns:
        0 到 1 之间的相似度分数

    Raises:
        ValueError: 如果任一文本为空
    """
    pass
```

### 安全第一
- 永远不要信任外部输入 - 在边界验证所有内容
- 将秘密保存在环境变量中，永远不要在代码中
- 记录安全事件（登录尝试、身份验证失败、速率限制、权限拒绝），但永远不要记录敏感数据（音频、对话内容、令牌、个人信息）
- 在 API 网关级别对用户进行身份验证 - 永远不要信任客户端令牌
- 使用行级安全性（RLS）强制用户之间的数据隔离
- 设计身份验证以在所有客户端类型中一致工作
- 为您的平台使用安全的身份验证模式
- 在创建会话之前验证所有服务器端的身份验证令牌
- 在存储或处理之前清理所有用户输入

### 错误处理
- 使用特定异常而不是通用异常
- 始终记录带上下文的错误
- 提供有用的错误消息
- 安全失败 - 错误不应泄露系统内部信息

### 可观察系统和日志标准
- 每个请求都需要用于调试的关联 ID
- 为机器而不是人类构建日志 - 使用 JSON 格式和一致的字段（时间戳、级别、correlation_id、事件、上下文）进行自动分析
- 使跨服务边界的调试成为可能

### 状态管理
- 每个状态都有一个真实来源
- 使状态更改明确且可追踪
- 为多服务语音处理设计 - 使用会话 ID 进行状态协调，避免在服务器内存中存储对话数据
- 保持对话历史轻量级（文本，而不是音频）

### API 设计原则
- 具有一致 URL 模式的 RESTful 设计
- 正确使用 HTTP 状态码
- 从第一天开始版本化 API（/v1/、/v2/）
- 支持列表端点的分页
- 使用一致的 JSON 响应格式：
  - 成功：`{ "data": {...}, "error": null }`
  - 错误：`{ "data": null, "error": {"message": "...", "code": "..."} }`


## 4. 多代理工作流和上下文注入

### 子代理的自动上下文注入
使用 Task 工具生成子代理时，核心项目上下文（CLAUDE.md、project-structure.md、docs-overview.md）通过 subagent-context-injector 钩子自动注入到它们的提示中。这确保所有子代理立即访问必要的项目文档，而无需在每个 Task 提示中手动指定。


## 5. MCP 服务器集成

### Gemini 咨询服务器
**何时使用：**
- 需要深入分析或多种方法的复杂编码问题
- 代码审查和架构讨论
- 跨多个文件调试复杂问题
- 性能优化和重构指导
- 复杂实现的详细解释
- 高度安全相关的任务

**自动上下文注入：**
- 套件的 `gemini-context-injector.sh` 钩子自动为新会话包含两个关键文件：
  - `/docs/ai-context/project-structure.md` - 完整的项目结构和技术栈
  - `/MCP-ASSISTANT-RULES.md` - 您的项目特定编码标准和指南
- 这确保 Gemini 始终全面了解您的技术栈、架构和项目标准

**使用模式：**
```python
# 新咨询会话（项目结构由钩子自动附加）
mcp__gemini__consult_gemini(
    specific_question="我应该如何优化这个语音管道？",
    problem_description="需要减少实时音频处理中的延迟",
    code_context="当前管道按顺序处理音频...",
    attached_files=[
        "src/core/pipelines/voice_pipeline.py"  # 您的特定文件
    ],
    preferred_approach="optimize"
)

# 在现有会话中跟进
mcp__gemini__consult_gemini(
    specific_question="内存使用情况如何？",
    session_id="session_123",
    additional_context="实施了您的建议，现在看到高内存使用"
)
```

**关键功能：**
- 具有上下文保留的持久对话会话
- 用于多文件分析的文件附件和缓存
- 专门的辅助模式（解决方案、审查、调试、优化、解释）
- 用于复杂、多步骤问题的会话管理

**重要提示：**将 Gemini 的响应视为咨询反馈。批判性地评估建议，将有价值的见解纳入您的解决方案，然后继续您的实施。

### Context7 文档服务器
**仓库**：[Context7 MCP Server](https://github.com/upstash/context7)

**何时使用：**
- 使用外部库/框架（React、FastAPI、Next.js 等）
- 需要超出训练截止日期的当前文档
- 使用第三方工具实现新的集成或功能
- 排除库特定问题

**使用模式：**
```python
# 将库名称解析为 Context7 ID
mcp__context7__resolve_library_id(libraryName="react")

# 获取重点文档
mcp__context7__get_library_docs(
    context7CompatibleLibraryID="/facebook/react",
    topic="hooks",
    tokens=8000
)
```

**关键功能：**
- 最新的库文档访问
- 以主题为重点的文档检索
- 支持特定的库版本
- 与当前开发实践集成



## 6. 任务完成后协议
完成任何编码任务后，请遵循此清单：

### 1. 类型安全和质量检查
根据修改的内容运行适当的命令：
- **Python 项目**：运行 mypy 类型检查
- **TypeScript 项目**：运行 tsc --noEmit
- **其他语言**：运行适当的 linting/类型检查工具

### 2. 验证
- 确保所有类型检查通过后再认为任务完成
- 如果发现类型错误，在标记任务完成之前修复它们