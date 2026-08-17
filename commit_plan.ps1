# ---------------------------------------------------------------------------
# Bu script tarihleri GERİYE ATMAZ — tüm commit'ler bugünün gerçek tarihiyle
# atılır. Yaptığı tek şey: bitmiş kodu tek seferde dump etmek yerine mantıklı,
# okunabilir parçalara bölerek commit'lemek.
#
# Kullanım:
#   1) Bu dosyayı proje kökü (plantapp\) içine kopyala.
#   2) PowerShell'de proje kökünde:  .\commit_plan.ps1
#   3) Çıktıyı kontrol et: git log --oneline
#   4) Sorun yoksa: git push -u origin main
#
# Not: Eğer "running scripts is disabled" hatası alırsan, PowerShell'i
# yönetici olarak açıp şunu bir kere çalıştır:
#   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
# ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

function Git-Commit {
    param(
        [string]$Message,
        [string[]]$Paths
    )
    $existing = $Paths | Where-Object { Test-Path $_ }
    if ($existing.Count -eq 0) {
        Write-Host "Atlandi (dosya bulunamadi): $Message" -ForegroundColor Yellow
        return
    }
    git add $existing
    $staged = git diff --cached --name-only
    if ([string]::IsNullOrWhiteSpace($staged)) {
        Write-Host "Atlandi (degisiklik yok): $Message" -ForegroundColor Yellow
        return
    }
    git commit -m "$Message"
}

$remoteUrl = "https://github.com/alberlevi98/plantapp.git"
$hasOrigin = git remote get-url origin 2>$null
if (-not $hasOrigin) {
    git remote add origin $remoteUrl
    Write-Host "origin remote eklendi: $remoteUrl"
}

# 1) Proje iskeleti
Git-Commit "chore: initial Flutter project scaffold" @(
    "pubspec.yaml", "pubspec.lock", "analysis_options.yaml", ".gitignore"
)

# 2) Design tokens, tema, responsive olcekleme
Git-Commit "core: add design tokens, theme, and responsive scaling utilities" @(
    "lib/core/constants", "lib/core/theme", "lib/core/extensions", "lib/core/utils"
)

# 3) Ag katmani, hata yonetimi, local storage
Git-Commit "core: add networking layer, error handling, and local storage" @(
    "lib/core/error", "lib/core/network", "lib/core/usecase", "lib/core/storage"
)

# 4) DI, router, app shell
Git-Commit "app: wire dependency injection and declarative routing" @(
    "lib/main.dart", "lib/app"
)

# 5) Paylasilan/ortak widget'lar
Git-Commit "shared: add reusable UI components (buttons, loaders, images, indicators)" @(
    "lib/shared"
)

# 6) Onboarding feature
Git-Commit "feat(onboarding): implement onboarding flow with Bloc" @(
    "lib/features/onboarding"
)

# 7) Paywall feature
Git-Commit "feat(paywall): implement paywall screen and plan selection" @(
    "lib/features/paywall"
)

# 8) Home feature - domain & data
Git-Commit "feat(home): add home domain entities, models, and repository" @(
    "lib/features/home/domain", "lib/features/home/data"
)

# 9) Home feature - presentation
Git-Commit "feat(home): implement home screen UI and HomeBloc" @(
    "lib/features/home/presentation"
)

# 10) Bozuk/sablon test dosyalarini kaldir
if (Test-Path "test/widget_test.dart") {
    git rm -f "test/widget_test.dart" 2>$null
}
if (Test-Path "test/features/onboarding/onboarding_cubit_test.dart") {
    git rm -f "test/features/onboarding/onboarding_cubit_test.dart" 2>$null
}
$staged = git diff --cached --name-only
if (-not [string]::IsNullOrWhiteSpace($staged)) {
    git commit -m "test: remove default counter template and stale Cubit test"
}

# 11) Gercek testler
Git-Commit "test: add unit tests for CategoryModel and HomeBloc" @(
    "test/features/home/category_model_test.dart", "test/features/home/home_bloc_test.dart"
)

Git-Commit "test: add OnboardingBloc unit tests" @(
    "test/features/onboarding/onboarding_bloc_test.dart"
)

Git-Commit "test: add PrimaryButton widget tests" @(
    "test/widget/primary_button_test.dart"
)

Write-Host ""
Write-Host "Tamamlandi. Kontrol icin: git log --oneline"
Write-Host "Sorun yoksa: git push -u origin main"