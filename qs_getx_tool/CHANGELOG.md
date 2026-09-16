## 1.0.4

- 将无原生能力的 Flutter plugin 转换为 Flutter package。
- 为公开工具类型统一添加 `Qs` 前缀并提供统一导出入口。
- 修复 ChangeNotifier 监听无法正确解绑的问题。
- 修复 DisposeBag 释放后仍可能加入并泄漏资源的问题。
- 调整 `QsGetxTimer.period`，使 `dueTime` 始终表示周期计时开始前的等待时间。
- 约束 GetX 依赖版本并完善示例、文档和测试。

### 迁移说明

- `DisposeBag` 改为 `QsDisposeBag`。
- `DisposeBagMixin` 改为 `QsDisposeBagMixin`。
- `DisposeController` 改为 `QsDisposeController`。
- `GetxTimer` 改为 `QsGetxTimer`。
- `GetxTool` 改为 `QsGetxTool`。
- `addlistener` 已删除，请改用带 `controller` 和 `listener` 命名参数的 `addListener`。

## 1.0.3

- 提供 GetX 监听、资源释放和周期定时器工具。
