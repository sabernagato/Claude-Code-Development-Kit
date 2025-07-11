# 文档架构

本项目使用**三层文档系统**，按稳定性和范围组织知识，实现高效的 AI 上下文加载和可扩展开发。

## 三层系统的工作原理

**第 1 层（基础层）**：稳定的系统级文档，很少变更 - 架构原则、技术决策、跨组件模式和核心开发协议。

**第 2 层（组件层）**：主要组件的架构章程 - 高层设计原则、集成模式和组件级约定，不包含特定功能的细节。

**第 3 层（功能特定层）**：与代码共置的细粒度文档 - 具体的实现模式、技术细节和随功能演进的本地架构决策。

这种层次结构允许 AI 代理高效加载目标上下文，同时保持核心知识的稳定基础。

## 文档原则
- **共置**：文档位于相关代码附近
- **智能扩展**：在必要时自动创建新的文档文件
- **AI 优先**：针对高效的 AI 上下文加载和机器可读模式进行优化

## 第 1 层：基础文档（系统级）

- **[主上下文](/CLAUDE.md)** - *每个会话必需。* 编码标准、安全要求、MCP 服务器集成模式和开发协议
- **[项目结构](/docs/ai-context/project-structure.md)** - *必读。* 完整的技术栈、文件树和系统架构。必须附加到 Gemini 咨询中
- **[系统集成](/docs/ai-context/system-integration.md)** - *用于跨组件工作。* 通信模式、数据流、测试策略和性能优化
- **[部署基础设施](/docs/ai-context/deployment-infrastructure.md)** - *基础设施模式。* 容器化、监控、CI/CD 工作流和扩展策略
- **[任务管理](/docs/ai-context/handoff.md)** - *会话连续性。* 当前任务、文档系统进度和下一个会话目标

## 第 2 层：组件级文档

### 后端组件
- **[后端上下文](/backend/CONTEXT.md)** - *服务器实现。* API 模式、数据库集成、服务架构和性能考虑
- **[工作服务](/workers/CONTEXT.md)** - *后台处理。* 作业队列模式、调度和异步任务管理
- **[共享库](/shared/CONTEXT.md)** - *可重用代码。* 通用工具、共享类型和跨组件功能

### 前端组件
- **[Web 应用程序](/frontend/CONTEXT.md)** - *客户端实现。* UI 模式、状态管理、路由和用户交互模式
- **[移动应用程序](/mobile/CONTEXT.md)** - *移动实现。* 平台特定模式、原生集成和移动优化
- **[管理仪表板](/admin/CONTEXT.md)** - *管理界面。* 权限模式、管理工作流和管理工具

### 基础设施组件
- **[基础设施代码](/infrastructure/CONTEXT.md)** - *IaC 模式。* Terraform/CloudFormation 模板、资源定义和部署自动化
- **[监控设置](/monitoring/CONTEXT.md)** - *可观测性模式。* 指标收集、警报规则和仪表板配置

## 第 3 层：功能特定文档

与代码共置的细粒度 CONTEXT.md 文件，以实现最小的级联效应：

### 后端功能文档
- **[核心服务](/backend/src/core/services/CONTEXT.md)** - *业务逻辑模式。* 服务架构、数据处理、集成模式和错误处理
- **[API 层](/backend/src/api/CONTEXT.md)** - *API 模式。* 端点设计、验证、中间件和请求/响应处理
- **[数据层](/backend/src/data/CONTEXT.md)** - *数据模式。* 数据库模型、查询、迁移和数据访问模式
- **[身份验证](/backend/src/auth/CONTEXT.md)** - *认证模式。* 身份验证流程、授权规则、会话管理和安全性
- **[集成](/backend/src/integrations/CONTEXT.md)** - *外部服务。* 第三方 API 客户端、webhook 处理程序和服务适配器

### 前端功能文档
- **[UI 组件](/frontend/src/components/CONTEXT.md)** - *组件模式。* 可重用组件、样式模式、可访问性和组合策略
- **[状态管理](/frontend/src/store/CONTEXT.md)** - *状态模式。* 全局状态、本地状态、数据流和持久化策略
- **[API 客户端](/frontend/src/api/CONTEXT.md)** - *客户端模式。* HTTP 客户端、错误处理、缓存和数据同步
- **[路由](/frontend/src/routes/CONTEXT.md)** - *导航模式。* 路由定义、守卫、延迟加载和深度链接
- **[工具函数](/frontend/src/utils/CONTEXT.md)** - *辅助函数。* 格式化器、验证器、转换器和通用工具

### 共享功能文档
- **[通用类型](/shared/src/types/CONTEXT.md)** - *类型定义。* 共享接口、枚举和类型工具
- **[验证规则](/shared/src/validation/CONTEXT.md)** - *验证模式。* 模式定义、自定义验证器和错误消息
- **[常量](/shared/src/constants/CONTEXT.md)** - *共享常量。* 配置值、枚举和魔法数字
- **[工具函数](/shared/src/utils/CONTEXT.md)** - *共享工具。* 跨平台辅助函数、格式化器和通用函数



## 添加新文档

### 新组件
1. 创建 `/new-component/CONTEXT.md`（第 2 层）
2. 在此文件的适当部分添加条目
3. 随着功能的开发创建特定功能的第 3 层文档

### 新功能
1. 创建 `/component/src/feature/CONTEXT.md`（第 3 层）
2. 引用父组件模式
3. 在此文件的组件功能下添加条目

### 弃用文档
1. 删除过时的 CONTEXT.md 文件
2. 更新此映射文档
3. 检查其他文档中的断开引用

---

*此文档架构模板应根据您项目的实际结构和组件进行自定义。根据您的架构添加或删除部分。*