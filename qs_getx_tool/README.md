# qs_getx_tool

`qs_getx_tool` 为 Flutter GetX 项目提供资源生命周期管理、响应式监听和周期定时器工具。

## 功能

- 统一管理 GetX `Worker`、`StreamSubscription`、`ChangeNotifier` 和 `Timer`。
- 在 GetX Controller 关闭时自动释放已注册资源。
- 提供自动纳入生命周期管理的 `ever`、`everAll` 和 `debounce`。
- 支持延迟启动的周期定时器。
- 重复释放安全；资源在 DisposeBag 释放后加入时会立即释放。

## 环境要求

- Dart `^3.10.3`
- Flutter `>=3.38.0`
- GetX `^4.7.3`

## 安装

```yaml
dependencies:
  qs_getx_tool: ^1.0.4
```

统一从主入口导入所有公开 API：

```dart
import 'package:get/get.dart';
import 'package:qs_getx_tool/qs_getx_tool.dart';
```

## 快速开始

继承 `QsDisposeController` 后，通过 `disposeBag` 注册的资源会在 `onClose` 中自动释放：

```dart
class HomeController extends QsDisposeController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    QsGetxTool.ever<int>(
      count,
      disposeBag: disposeBag,
      callback: (value) {
        // 处理变化
      },
    );
  }
}
```

也可以通过 `QsDisposeBagMixin` 为其他类型提供相同的资源容器，并在自身生命周期结束时调用 `disposeDisposeBag()`。

## 响应式监听

### 监听单个响应式变量

```dart
QsGetxTool.ever<int>(
  count,
  disposeBag: disposeBag,
  callback: (value) {
    // 处理变化
  },
);
```

### 监听多个响应式变量

```dart
QsGetxTool.everAll(
  [firstCount, secondCount],
  disposeBag: disposeBag,
  callback: (values) {
    // 任意变量变化时处理
  },
);
```

### 防抖监听

```dart
QsGetxTool.debounce<String>(
  keyword,
  time: const Duration(milliseconds: 300),
  disposeBag: disposeBag,
  callback: (value) {
    // 输入停止 300 毫秒后处理
  },
);
```

以上监听产生的资源都会加入指定的 `QsDisposeBag`，调用 `dispose()` 后不再触发回调。

## 管理资源

`QsDisposeBag` 支持以下注册方法：

| 方法 | 管理的资源 |
| --- | --- |
| `addWorker` | GetX `Worker` |
| `addStreamSubscription` | `StreamSubscription` |
| `addController` | `ChangeNotifier`，释放时调用其 `dispose()` |
| `addListener` | `ChangeNotifier` 监听，释放时使用原回调解绑 |
| `addTimer` | `Timer` |

### 管理 ChangeNotifier 监听

`addListener` 会同时注册并保存监听回调，释放时使用同一个回调准确解绑：

```dart
final disposeBag = QsDisposeBag();
final controller = TextEditingController();

void handleTextChanged() {
  // 处理文本变化
}

disposeBag.addListener(
  controller: controller,
  listener: handleTextChanged,
);

disposeBag.dispose();
```

`QsDisposeBag` 重复调用 `dispose()` 是安全的。DisposeBag 释放后加入的 Worker、Timer、StreamSubscription 和 ChangeNotifier 会被立即释放；新的监听回调不会再注册。

## 周期定时器

`dueTime` 表示开始周期计时前的等待时间。以下示例会等待 1 秒，再每 5 秒回调一次：

```dart
await QsGetxTimer.period(
  dueTime: const Duration(seconds: 1),
  duration: const Duration(seconds: 5),
  disposeBag: disposeBag,
  callback: (timer) {
    // 处理周期任务
  },
);
```

等待期间 DisposeBag 被释放时，后续创建的周期定时器会立即取消，不会产生回调。

不需要延迟时可省略 `dueTime`：

```dart
final timer = await QsGetxTimer.period(
  duration: const Duration(seconds: 5),
  disposeBag: disposeBag,
  callback: (timer) {
    // 处理周期任务
  },
);
```

## 从 1.0.3 迁移

`1.0.4` 将该项目从包含 Android、iOS 模板代码的 Flutter plugin 调整为无需原生实现的 Flutter package，并统一了公开类型命名：

| 旧 API | 新 API |
| --- | --- |
| `DisposeBag` | `QsDisposeBag` |
| `DisposeBagMixin` | `QsDisposeBagMixin` |
| `DisposeController` | `QsDisposeController` |
| `GetxTimer` | `QsGetxTimer` |
| `GetxTool` | `QsGetxTool` |

旧的 `addlistener(ChangeNotifier)` 已删除。请改用能够保存并准确解绑回调的 `addListener`：

```dart
disposeBag.addListener(
  controller: controller,
  listener: handleTextChanged,
);
```
