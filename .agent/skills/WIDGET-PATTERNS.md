# 🧩 Widget Patterns - ZECA App

> **Padrões de composição e organização de Widgets.**

---

## 📐 Estrutura de Page

### Padrão com BLoC

```dart
// refueling_page.dart

class RefuelingPage extends StatelessWidget {
  const RefuelingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RefuelingBloc>()..add(const LoadRequested()),
      child: const _RefuelingView(),
    );
  }
}

class _RefuelingView extends StatelessWidget {
  const _RefuelingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abastecimentos')),
      body: const _RefuelingBody(),
    );
  }
}

class _RefuelingBody extends StatelessWidget {
  const _RefuelingBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefuelingBloc, RefuelingState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const _LoadingView(),
          loaded: (items) => _LoadedView(items: items),
          empty: () => const _EmptyView(),
          error: (message) => _ErrorView(message: message),
        );
      },
    );
  }
}
```

---

## 🔄 Estados de UI

### Loading

```dart
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

// Loading com shimmer
class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => const _ShimmerCard(),
    );
  }
}
```

### Empty

```dart
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum abastecimento',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Seus abastecimentos aparecerão aqui',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
```

### Error

```dart
class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<RefuelingBloc>().add(const LoadRequested());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📋 Listas

### ListView.builder

```dart
class _RefuelingList extends StatelessWidget {
  final List<Refueling> items;

  const _RefuelingList({required this.items});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<RefuelingBloc>().add(const RefreshRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RefuelingCard(
              key: ValueKey(item.id),
              refueling: item,
              onTap: () => _onItemTap(context, item),
            ),
          );
        },
      ),
    );
  }

  void _onItemTap(BuildContext context, Refueling item) {
    context.push('/refueling/${item.id}');
  }
}
```

### ListView.separated

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (_, __) => const Divider(height: 1),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].name),
    );
  },
)
```

---

## 🎨 Componentes Reutilizáveis

### Card Pattern

```dart
class RefuelingCard extends StatelessWidget {
  final Refueling refueling;
  final VoidCallback? onTap;

  const RefuelingCard({
    super.key,
    required this.refueling,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(refueling: refueling),
              const SizedBox(height: 12),
              _Details(refueling: refueling),
              const SizedBox(height: 12),
              _Footer(refueling: refueling),
            ],
          ),
        ),
      ),
    );
  }
}

// Widgets internos privados
class _Header extends StatelessWidget { ... }
class _Details extends StatelessWidget { ... }
class _Footer extends StatelessWidget { ... }
```

### Button Patterns

```dart
// Primary Action
FilledButton(
  onPressed: () {},
  child: const Text('Confirmar'),
)

// Secondary Action
OutlinedButton(
  onPressed: () {},
  child: const Text('Cancelar'),
)

// Icon Button
IconButton(
  onPressed: () {},
  icon: const Icon(Icons.refresh),
)

// Loading Button
class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : child,
    );
  }
}
```

---

## 📝 Formulários

### Form Pattern

```dart
class RefuelingForm extends StatelessWidget {
  const RefuelingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefuelingFormBloc, RefuelingFormState>(
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _VehicleDropdown(
                value: state.vehicleId,
                vehicles: state.vehicles,
                error: state.vehicleError,
              ),
              const SizedBox(height: 16),
              _LitersField(
                value: state.liters,
                error: state.litersError,
              ),
              const SizedBox(height: 24),
              LoadingButton(
                isLoading: state.isSubmitting,
                onPressed: state.canSubmit ? () => _submit(context) : null,
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    context.read<RefuelingFormBloc>().add(const FormSubmitted());
  }
}
```

### Input Fields

```dart
class _LitersField extends StatelessWidget {
  final double value;
  final String? error;

  const _LitersField({
    required this.value,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value > 0 ? value.toString() : '',
      decoration: InputDecoration(
        labelText: 'Litros',
        hintText: 'Ex: 50.5',
        errorText: error,
        suffixText: 'L',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final liters = double.tryParse(value) ?? 0;
        context.read<RefuelingFormBloc>().add(LitersChanged(liters));
      },
    );
  }
}
```

---

## 🔲 Layout Patterns

### Responsive Layout

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200 && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= 600 && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
```

### SafeArea Pattern

```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        // Header
        _Header(),
        // Content
        Expanded(child: _Content()),
        // Footer (se necessário)
        _Footer(),
      ],
    ),
  ),
)
```

---

## 🎭 Animações

### Fade Transition

```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: isLoading
      ? const LoadingWidget(key: ValueKey('loading'))
      : ContentWidget(key: ValueKey('content')),
)
```

### Animated Container

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  height: isExpanded ? 200 : 60,
  color: isSelected ? Colors.blue : Colors.white,
  child: content,
)
```

---

## ✅ Checklist

```
Novo Widget:
□ Preferir StatelessWidget quando possível
□ Usar const constructor
□ Extrair widgets grandes em componentes menores
□ Usar Key para listas dinâmicas
□ Tratar todos os estados (loading, error, empty)
□ Usar Theme.of(context) para cores/estilos
□ Responsividade com MediaQuery/LayoutBuilder
□ Acessibilidade (Semantics, labels)
```

---

*Widget Patterns v2.0.0 - Janeiro 2026*
