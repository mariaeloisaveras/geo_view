# GeoView

Aplicativo Flutter para visualizar dados geográficos carregados de um arquivo GeoJSON local e sobrepor a sua localização atual no mapa.

## ✨ Funcionalidades
- Renderização de tiles OpenStreetMap via `flutter_map`
- Leitura de áreas a partir de `assets/geo/areas.geojson`
- Arquitetura com Riverpod (`ProviderScope`) e camadas de domínio/dados
- Pin azul com a localização do usuário (Geolocator com refinamento de precisão)
- Marcadores interativos: toque no mapa para adicionar novos pins
- Hot reload/restart integrado para desenvolvimento rápido

## 🔧 Requisitos
- Flutter SDK 3.5 ou superior (canal stable recomendado)
- Chrome instalado (para execução web)
- Permissão de localização concedida ao Chrome
- Dispositivo com serviços de localização habilitados

Verifique a versão instalada:
```bash
flutter --version
```

## 🚀 Como rodar
```bash
flutter pub get
flutter run -d chrome --debug
```

Durante a primeira execução no Chrome:
1. Aceite o pedido de permissão de localização.
2. Se necessário, clique no ícone de cadeado → “Configurações do site” → “Localização” → “Permitir”.
3. Use o botão com o ícone de alvo para centralizar novamente no seu ponto atual e ver a precisão reportada.

### Hot reload automático
- VS Code: habilite a opção `Dart: Flutter Hot Reload On Save`.
- Android Studio/IntelliJ: `Settings > Languages & Frameworks > Flutter > Perform hot reload on save`.
- Terminal: pressione `r` para hot reload e `R` para hot restart.

## 🧱 Estrutura principal
```
lib/
├─ main.dart                # Entrada da aplicação com ProviderScope
├─ app.dart                 # Configuração de tema e rota inicial
└─ src/features/map/
   ├─ data/                 # Datasource local e repositório GeoJSON
   ├─ domain/               # Entidades, abstrações e use cases
   └─ presentation/
      ├─ pages/map_page.dart   # Tela principal com ações de UI
      ├─ providers/            # Providers Riverpod
      └─ widgets/map_view.dart # FlutterMap e gerenciamento de marcadores
```

## ✅ Testes
Execute a suíte padrão:
```bash
flutter test
```

## 📦 Build de produção web
```bash
flutter build web
```
Os arquivos finais ficarão em `build/web`.

## 🤝 Contribuindo
1. Faça um fork do repositório
2. Crie uma branch de feature: `git checkout -b feature/nome-da-feature`
3. Commit com mensagens descritivas: `git commit -m "feat: adiciona localização precisa"`
4. Abra um Pull Request detalhando as mudanças

---

Se tiver dúvidas ou quiser sugerir melhorias, fique à vontade para abrir uma issue ou falar comigo. 🗺️
