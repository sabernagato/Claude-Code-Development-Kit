# /gemini-consult

*与 Gemini MCP 进行深入、迭代的对话，用于复杂问题解决。*

## 用法
- **带参数**：`/gemini-consult [具体问题或疑问]`
- **无参数**：`/gemini-consult` - 智能地从当前上下文推断主题

## 核心理念
通过以下方式为不断发展的问题提供持久的 Gemini 会话：
- **持续对话** - 多轮对话直到达成清晰理解
- **上下文感知** - 从当前工作中智能检测问题
- **会话持久性** - 在整个问题生命周期中保持活跃

## 执行

用户提供的上下文："$ARGUMENTS"

### 步骤 1：理解问题

**当 $ARGUMENTS 为空时：**
深入思考当前上下文以推断最有价值的咨询主题：
- 哪些文件是打开的或最近修改过的？
- 讨论了哪些错误或挑战？
- 哪些复杂实现会从 Gemini 的分析中受益？
- 哪些架构决策需要探索？

基于此分析生成一个具体、有价值的问题。

**当提供参数时：**
提取核心问题、上下文线索和复杂性指标。

### 步骤 2：初始化 Gemini 会话

**关键：始终附加基础文件：**
```python
foundational_files = [
    "MCP-ASSISTANT-RULES.md",  # If exists
    "docs/ai-context/project-structure.md",
    "docs/ai-context/docs-overview.md"
]

# 检查 MCP-ASSISTANT-RULES.md 是否存在
import os
if os.path.exists("MCP-ASSISTANT-RULES.md"):
    foundational_files.insert(0, "MCP-ASSISTANT-RULES.md")

session = mcp__gemini__consult_gemini(
    specific_question="[Clear, focused question]",
    problem_description="[Comprehensive context with constraints from CLAUDE.md]",
    code_context="[Relevant code snippets]",
    attached_files=foundational_files + [problem_specific_files],
    file_descriptions={
        "MCP-ASSISTANT-RULES.md": "项目愿景和编码标准",
        "docs/ai-context/project-structure.md": "完整的技术栈和文件结构",
        "docs/ai-context/docs-overview.md": "文档架构",
        # 添加特定问题的描述
    },
    preferred_approach="[solution/review/debug/optimize/explain]"
)
```

### 步骤 3：进行深入对话

**深入思考如何从对话中获得最大价值：**

1. **主动分析**
   - Gemini 做了哪些假设？
   - 什么需要澄清或更深入的探索？
   - 应该讨论哪些边缘案例或替代方案？

2. **迭代改进**
   ```python
   follow_up = mcp__gemini__consult_gemini(
       specific_question="[有针对性的后续问题]",
       session_id=session["session_id"],
       additional_context="[新的洞察、问题或实施反馈]",
       attached_files=[newly_relevant_files]
   )
   ```

3. **实施反馈循环**
   分享实际代码更改和现实世界的结果以改进方法。

### 步骤 4：会话管理

**保持会话打开** - 不要立即关闭。在整个问题生命周期中保持活跃。

**仅在以下情况下关闭：**
- 问题已经明确解决并测试
- 主题不再相关
- 重新开始会更有益

**监控会话：**
```python
active = mcp__gemini__list_sessions()
requests = mcp__gemini__get_gemini_requests(session_id="...")
```

## 关键模式

### 澄清模式
"您提到了 [X]。在我们 [项目特定情况] 的上下文中，这如何应用于 [具体关注点]？"

### 深入探索模式
"让我们进一步探索 [方面]。考虑到我们的 [约束]，有哪些权衡？"

### 替代方案模式
"如果我们将其作为 [替代方案] 来处理会怎样？这将如何影响 [关注点]？"

### 进度检查模式
"我已经实施了 [更改]。这是发生的情况：[结果]。我应该调整方法吗？"

## 最佳实践

1. **深入思考** 每次交互前 - 什么可以提取最大的洞察？
2. **具体明确** - 模糊的问题得到模糊的答案
3. **展示实际代码** - 而不是描述
4. **挑战假设** - 不要接受不清晰的指导
5. **记录决策** - 为将来参考捕获“为什么”
6. **保持好奇** - 探索替代方案和边缘案例
7. **信任但验证** - 彻底测试所有建议

## 实施方法

实施 Gemini 建议时：
1. 从影响最大的更改开始
2. 增量测试
3. 将结果反馈给 Gemini
4. 基于现实世界的反馈进行迭代
5. 在适当的 CONTEXT.md 文件中记录关键洞察

## 记住

- 这是一次**对话**，而不是查询服务
- **上下文为王** - 更多上下文产生更好的指导
- **Gemini 能看到您可能错过的模式** - 对意外的洞察保持开放
- **实施揭示真相** - 分享实际发生的情况
- 将 Gemini 视为**协作思考伙伴**，而不是神谕

目标是通过迭代改进深入理解和优化解决方案，而不是快速答案。