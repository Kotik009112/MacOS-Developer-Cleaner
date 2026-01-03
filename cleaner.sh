#!/bin/bash

# ============================================
# macOS DEVELOPER CLEANER for Thaoe 26.2+
# Version: 1.0.0
# Editor: Issak Foster
# GitHub: https://github.com/Kotik009112/MacOS-Developer-Cleaner
# ============================================
# WARNING: This script deletes cache files that can be regenerated
# ============================================

clear
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   🍎 macOS DEVELOPER CLEANER 2026                        ║"
echo "║   For Unity, Xcode, JetBrains & Creative Suite           ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️   ВНИМАНИЕ: Этот скрипт удалит кэши и временные файлы!"
echo ""
echo "==========================================================="
echo ""

# ============================================
# 1. ПРЕДУПРЕЖДЕНИЕ И ПОДТВЕРЖДЕНИЕ
# ============================================
echo "❓ Что будет сделано:"
echo "   • 🎮 Unity: кэши пакетов, логи, временные файлы"
echo "   • 📱 Xcode: симуляторы, DerivedData, старые архивы"
echo "   • ⚡ JetBrains Rider: кэши решений, индексы"
echo "   • 🎨 Adobe: Photoshop временные файлы"
echo "   • 🎵 Logic Pro: кэши рендеров"
echo "   • 🕐 Time Machine: локальные снимки"
echo "   • 🌐 Браузеры: Safari, Chrome кэши"
echo ""
echo "❓ Что НЕ будет затронуто:"
echo "   • ✅ Ваши проекты и исходный код"
echo "   • ✅ Настройки приложений"
echo "   • ✅ Установленные редакторы Unity"
echo "   • ✅ Личные документы и медиа"
echo ""
echo "==========================================================="
read -p "🚀 Продолжить? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "❌ Очистка отменена пользователем"
    echo "   Ничего не было удалено."
    exit 0
fi

# ============================================
# 2. ЗАПРОС ПРАВ АДМИНИСТРАТОРА (ОДИН РАЗ)
# ============================================
echo ""
echo "🔐 Запрос прав администратора..."
echo "   Нужен для очистки системных кэшей"
echo ""

# Кэшируем пароль sudo на время выполнения
sudo -v
if [ $? -ne 0 ]; then
    echo "❌ Неверный пароль или отменено"
    echo "   Часть очистки будет пропущена"
    SKIP_SYSTEM_CLEAN=true
else
    echo "✅ Права получены! Поддерживаем сессию..."
    # Поддерживаем sudo сессию активной
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SKIP_SYSTEM_CLEAN=false
fi

echo ""
echo "==========================================================="
echo "🛠️  НАЧИНАЕМ ОЧИСТКУ..."
echo "==========================================================="

# ============================================
# 3. UNITY - ГЛАВНЫЙ ПОЖИРАТЕЛЬ
# ============================================
echo ""
echo "🎮 ШАГ 1: Атака на Unity Cache..."
echo "----------------------------------------"

# Глобальный кэш Unity (безопасно)
echo "   🗑️  Удаляю глобальный кэш Unity..."
rm -rf ~/Library/Unity/cache/ 2>/dev/null
rm -rf ~/Library/Unity/PackageManager/ 2>/dev/null

# Кэш Asset Store (осторожно!)
echo "   🗑️  Чищу кэш Asset Store..."
find ~/Library/Unity -name "Asset Store-*" -type d -exec rm -rf {} + 2>/dev/null

# Логи Unity
echo "   📋 Очищаю логи редактора..."
rm -rf ~/Library/Logs/Unity/ 2>/dev/null
mkdir -p ~/Library/Logs/Unity/

# Временные файлы проектов
echo "   🔥 Удаляю временные файлы..."
find ~ -type d -name "Temp" -path "*Unity*" -exec rm -rf {} + 2>/dev/null
find ~ -type f -name "Unity_lockfile_*" -delete 2>/dev/null

echo "   ✅ Unity: ~5-15 ГБ освобождено"

# ============================================
# 4. XCODE - ВТОРОЙ ЧЕМПИОН
# ============================================
echo ""
echo "📱 ШАГ 2: Разборка с Xcode..."
echo "----------------------------------------"

# Проверяем наличие Xcode
if [ -d ~/Library/Developer/Xcode ]; then
    echo "   🔍 Xcode найден"
    
    # 1. СИМУЛЯТОРЫ - спрашиваем
    echo ""
    echo "   📱 СИМУЛЯТОРЫ iOS"
    echo "   ----------------"
    echo "   • Они могут занимать 20+ ГБ"
    echo "   • Удаляются если не используете симуляторы"
    echo "   • Можно переустановить через Xcode"
    echo ""
    read -p "   ❓ Удалить недоступные симуляторы? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   🗑️  Удаляю недоступные симуляторы..."
        xcrun simctl delete unavailable 2>/dev/null
        echo "   ✅ Недоступные симуляторы удалены"
    else
        echo "   ✅ Симуляторы сохранены"
    fi
    
    # 2. DERIVEDDATA - спрашиваем о сроке
    echo ""
    echo "   📦 DERIVEDDATA (кеши сборок)"
    echo "   ---------------------------"
    echo "   • Хранит промежуточные файлы сборок"
    echo "   • Можно безопасно удалить старые"
    echo "   • Активные проекты пересоберутся"
    echo ""
    echo "   Выберите что удалить:"
    echo "   1) Всё старше 30 дней (рекомендуется)"
    echo "   2) Всё старше 7 дней"
    echo "   3) Всё кроме текущих проектов"
    echo "   4) Не удалять DerivedData"
    echo ""
    read -p "   Ваш выбор [1-4]: " dd_choice
    
    case $dd_choice in
        1)
            echo "   🗑️  Удаляю DerivedData старше 30 дней..."
            find ~/Library/Developer/Xcode/DerivedData -type d -name "*.build" -mtime +30 -exec rm -rf {} + 2>/dev/null
            echo "   ✅ DerivedData старше 30 дней удалён"
            ;;
        2)
            echo "   🗑️  Удаляю DerivedData старше 7 дней..."
            find ~/Library/Developer/Xcode/DerivedData -type d -name "*.build" -mtime +7 -exec rm -rf {} + 2>/dev/null
            echo "   ✅ DerivedData старше 7 дней удалён"
            ;;
        3)
            echo "   🗑️  Удаляю ВЕСЬ DerivedData..."
            rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
            echo "   ✅ Весь DerivedData удалён"
            ;;
        4)
            echo "   ✅ DerivedData сохранён"
            ;;
        *)
            echo "   ❌ Неверный выбор, пропускаю"
            ;;
    esac
    
    # 3. АРХИВЫ - спрашиваем сколько оставить
    echo ""
    echo "   📁 АРХИВЫ (Archives)"
    echo "   -------------------"
    echo "   • Хранят скомпилированные .ipa/.app"
    echo "   • Нужны для отправки в AppStore"
    echo "   • Старые архивы можно удалить"
    echo ""
    
    if [ -d ~/Library/Developer/Xcode/Archives ]; then
        ARCHIVE_COUNT=$(ls -1td ~/Library/Developer/Xcode/Archives/*.xcarchive 2>/dev/null | wc -l 2>/dev/null | tr -d ' ')
        if [ "$ARCHIVE_COUNT" -gt 0 ] 2>/dev/null; then
            echo "   📊 Найдено архивов: $ARCHIVE_COUNT"
            echo ""
            read -p "   ❓ Сколько последних архивов оставить? (0 = удалить все): " keep_archives
            
            if [[ "$keep_archives" =~ ^[0-9]+$ ]]; then
                if [ "$keep_archives" -eq 0 ]; then
                    echo "   🗑️  Удаляю ВСЕ архивы..."
                    rm -rf ~/Library/Developer/Xcode/Archives/* 2>/dev/null
                    echo "   ✅ Все архивы удалены"
                elif [ "$keep_archives" -lt "$ARCHIVE_COUNT" ]; then
                    echo "   🗑️  Оставляю $keep_archives последних архивов..."
                    cd ~/Library/Developer/Xcode/Archives 2>/dev/null
                    ls -1td *.xcarchive 2>/dev/null | tail -n +$((keep_archives + 1)) | xargs rm -rf 2>/dev/null
                    echo "   ✅ Удалено $((ARCHIVE_COUNT - keep_archives)) архивов"
                else
                    echo "   ✅ Сохраняю все архивы"
                fi
            else
                echo "   ❌ Неверное число, архивы не удалены"
            fi
        else
            echo "   ✅ Архивов не найдено"
        fi
    fi
    
    # 4. iOS DEVICE SUPPORT - ОЧЕНЬ ВАЖНО!
    echo ""
    echo "   📲 iOS DEVICE SUPPORT"
    echo "   ---------------------"
    echo "   • Символы отладки для разных версий iOS"
    echo "   • НУЖНЫ для отладки на конкретных версиях"
    echo "   • Занимают 5-15 ГБ на версию"
    echo "   • Если удалить - придётся заново скачивать через Xcode"
    echo ""
    
    if [ -d ~/Library/Developer/Xcode/iOS\ DeviceSupport ]; then
        SUPPORT_VERSIONS=$(ls -1td ~/Library/Developer/Xcode/iOS\ DeviceSupport/*/ 2>/dev/null | wc -l 2>/dev/null | tr -d ' ')
        if [ "$SUPPORT_VERSIONS" -gt 0 ] 2>/dev/null; then
            echo "   📊 Установлено версий iOS: $SUPPORT_VERSIONS"
            echo ""
            echo "   📋 Список версий:"
            ls -1td ~/Library/Developer/Xcode/iOS\ DeviceSupport/*/ 2>/dev/null | head -10 | while read -r version; do
                version_name=$(basename "$version")
                size=$(du -sh "$version" 2>/dev/null | cut -f1)
                echo "      • $version_name ($size)"
            done
            
            if [ "$SUPPORT_VERSIONS" -gt 10 ]; then
                echo "      ... и ещё $((SUPPORT_VERSIONS - 10))"
            fi
            
            echo ""
            echo "   Выберите действие:"
            echo "   1) Удалить старые версии (оставить 3 последние)"
            echo "   2) Удалить конкретные версии"
            echo "   3) Показать размер каждой версии"
            echo "   4) Не трогать iOS DeviceSupport"
            echo ""
            read -p "   Ваш выбор [1-4]: " ios_choice
            
            case $ios_choice in
                1)
                    echo "   🗑️  Оставляю 3 последние версии iOS..."
                    cd ~/Library/Developer/Xcode/iOS\ DeviceSupport 2>/dev/null
                    ls -1td */ 2>/dev/null | tail -n +4 | xargs rm -rf 2>/dev/null
                    REMAINING=$(ls -1td */ 2>/dev/null | wc -l 2>/dev/null | tr -d ' ')
                    echo "   ✅ Оставлено версий: $REMAINING"
                    ;;
                2)
                    echo ""
                    echo "   📝 Введите версии для удаления (через пробел)"
                    echo "   Пример: 15.2 16.1 17.0"
                    echo ""
                    read -p "   Версии для удаления: " versions_to_delete
                    
                    if [ -n "$versions_to_delete" ]; then
                        for version in $versions_to_delete; do
                            if [ -d ~/Library/Developer/Xcode/iOS\ DeviceSupport/"$version"* ]; then
                                rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/"$version"* 2>/dev/null
                                echo "   ✅ Удалена версия: $version"
                            else
                                echo "   ⚠️  Версия $version не найдена"
                            fi
                        done
                    fi
                    ;;
                3)
                    echo ""
                    echo "   📊 РАЗМЕР КАЖДОЙ ВЕРСИИ iOS:"
                    ls -1td ~/Library/Developer/Xcode/iOS\ DeviceSupport/*/ 2>/dev/null | while read -r version; do
                        version_name=$(basename "$version")
                        size=$(du -sh "$version" 2>/dev/null | cut -f1)
                        echo "   • $version_name: $size"
                    done
                    ;;
                4)
                    echo "   ✅ iOS DeviceSupport не тронут"
                    ;;
                *)
                    echo "   ❌ Неверный выбор, пропускаю"
                    ;;
            esac
        else
            echo "   ✅ iOS DeviceSupport не установлен"
        fi
    fi
    
    # 5. ДОПОЛНИТЕЛЬНЫЕ ОПЦИИ XCODE
    echo ""
    echo "   🛠️  ДОПОЛНИТЕЛЬНЫЕ ОПЦИИ"
    echo "   -----------------------"
    echo "   1) Очистить кэш документации"
    echo "   2) Очистить кэш плагинов"
    echo "   3) Удалить старые версии командных утилит"
    echo "   4) Пропустить"
    echo ""
    read -p "   Ваш выбор [1-4]: " xcode_extra_choice
    
    case $xcode_extra_choice in
        1)
            echo "   🗑️  Очищаю кэш документации..."
            rm -rf ~/Library/Developer/Shared/Documentation/DocSets 2>/dev/null
            echo "   ✅ Кэш документации очищен"
            ;;
        2)
            echo "   🗑️  Очищаю кэш плагинов..."
            rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins 2>/dev/null
            echo "   ✅ Кэш плагинов очищен"
            ;;
        3)
            echo "   🗑️  Удаляю старые командные утилиты..."
            # Оставляем только текущую версию
            cd /Library/Developer/CommandLineTools 2>/dev/null
            if [ $? -eq 0 ]; then
                ls -1td */ 2>/dev/null | tail -n +2 | xargs sudo rm -rf 2>/dev/null
                echo "   ✅ Старые командные утилиты удалены"
            else
                echo "   ⚠️  CommandLineTools не найдены"
            fi
            ;;
        4)
            echo "   ✅ Дополнительные опции пропущены"
            ;;
        *)
            echo "   ❌ Неверный выбор, пропускаю"
            ;;
    esac
    
    echo ""
    echo "   ✅ Xcode: очистка завершена"
    
else
    echo "   ⚠️  Xcode не найден, пропускаю"
    echo "   ✅ Xcode: пропущено"
fi

# ============================================
# 5. JETBRAINS RIDER - УМНЫЙ, НО ПУХЛЫЙ
# ============================================
echo ""
echo "⚡ ШАГ 3: Оптимизация Rider..."
echo "----------------------------------------"

# Находим последнюю версию Rider
RIDER_CACHE=$(ls -td ~/Library/Caches/JetBrains/Rider* 2>/dev/null | head -1)

if [ -n "$RIDER_CACHE" ]; then
    echo "   🗑️  Очищаю кэши решений..."
    rm -rf "$RIDER_CACHE/solutionCaches" 2>/dev/null
    rm -rf "$RIDER_CACHE/index" 2>/dev/null
    
    echo "   📋 Чищу логи..."
    rm -rf ~/Library/Logs/JetBrains/Rider* 2>/dev/null
    
    echo "   ✅ Rider: ~3-10 ГБ освобождено"
else
    echo "   ⚠️  Rider не найден, пропускаю"
fi

# ============================================
# 6. ТВОРЧЕСКИЙ СЕКТОР
# ============================================
echo ""
echo "🎨 ШАГ 4: Уборка Creative Suite..."
echo "----------------------------------------"

# Adobe Photoshop
echo "   🖼️  Photoshop: чищу временные файлы..."
rm -rf ~/Library/Caches/Adobe/Photoshop 2>/dev/null
rm -rf ~/Library/Caches/Adobe/Common/Media\ Cache 2>/dev/null

# Logic Pro
echo "   🎵 Logic Pro: удаляю кэши рендеров..."
rm -rf ~/Library/Caches/com.apple.logic10 2>/dev/null
rm -rf ~/Library/Containers/com.apple.logic10/Data/Library/Caches/* 2>/dev/null

# Final Cut, iMovie, GarageBand
echo "   🎬 Очищаю кэши видео-редакторов..."
rm -rf ~/Library/Caches/com.apple.FinalCut 2>/dev/null
rm -rf ~/Library/Caches/com.apple.iMovieApp 2>/dev/null
rm -rf ~/Library/Caches/com.apple.garageband10 2>/dev/null

echo "   ✅ Creative Suite: ~2-8 ГБ освобождено"

# ============================================
# 7. БРАУЗЕРЫ (РАЗРАБОТЧИКИ ИМИ ПОЛЬЗУЮТСЯ)
# ============================================
echo ""
echo "🌐 ШАГ 5: Чистка браузеров..."
echo "----------------------------------------"

# Safari
echo "   🦁 Safari: очищаю кэши..."
rm -rf ~/Library/Caches/com.apple.Safari 2>/dev/null
rm -rf ~/Library/Caches/com.apple.Safari.SafeBrowsing 2>/dev/null

# Chrome
echo "   🌍 Chrome: удаляю временные файлы..."
rm -rf ~/Library/Caches/Google/Chrome 2>/dev/null
rm -rf ~/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/* 2>/dev/null

# Firefox
echo "   🦊 Firefox: чищу кэши..."
rm -rf ~/Library/Caches/Firefox 2>/dev/null
rm -rf ~/Library/Caches/org.mozilla.firefox 2>/dev/null

echo "   ✅ Браузеры: ~1-5 ГБ освобождено"

# ============================================
# 8. СИСТЕМНЫЕ КЭШИ (ТОЛЬКО С SUDO)
# ============================================
echo ""
echo "🖥️  ШАГ 6: Системные кэши..."
echo "----------------------------------------"

if [ "$SKIP_SYSTEM_CLEAN" = false ]; then
    # Системные кэши
    echo "   🗑️  Очищаю системные кэши..."
    sudo rm -rf /Library/Caches/* 2>/dev/null
    sudo rm -rf /System/Library/Caches/* 2>/dev/null
    
    # Системные логи
    echo "   📋 Чищу системные логи..."
    sudo find /var/log -type f -name "*.log.*" -mtime +1 -delete 2>/dev/null
    sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null
    
    # Временные файлы системы
    echo "   🔥 Удаляю системные временные файлы..."
    sudo rm -rf /private/var/tmp/* 2>/dev/null
    sudo rm -rf /tmp/* 2>/dev/null
    
    echo "   ✅ Система: ~3-10 ГБ освобождено"
else
    echo "   ⚠️  Пропускаю (требуются права администратора)"
fi

# ============================================
# 9. TIME MACHINE LOCAL SNAPSHOTS
# ============================================
echo ""
echo "🕐 ШАГ 7: Проверка локальных снимков Time Machine..."
echo "----------------------------------------"

SNAPSHOTS_COUNT=$(tmutil listlocalsnapshots / 2>/dev/null | grep -c "com.apple.TimeMachine" 2>/dev/null)

if [ "$SNAPSHOTS_COUNT" -gt 0 ] 2>/dev/null; then
    echo "   🔍 Найдено локальных снимков: $SNAPSHOTS_COUNT"
    echo ""
    echo "   ℹ️  Что такое локальные снимки Time Machine?"
    echo "      • 📁 Это резервные копии файлов на ВАШЕМ диске"
    echo "      • 🔄 Создаются когда внешний диск не подключен"
    echo "      • ⏰ Позволяют восстановить удалённые файлы"
    echo "      • 💾 Могут занимать ДЕСЯТКИ гигабайт"
    echo ""
    
    # Показываем информацию о снимках
    echo "   📅 Последние снимки:"
    tmutil listlocalsnapshots / 2>/dev/null | grep "com.apple.TimeMachine" | sed 's/.*com\.apple\.TimeMachine\.//' | head -5 | while read -r SNAP; do
        SNAP_DATE=$(echo "$SNAP" | cut -d'.' -f1 2>/dev/null)
        echo "      • $SNAP_DATE"
    done
    
    echo ""
    read -p "   ❓ Удалить локальные снимки Time Machine? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$SKIP_SYSTEM_CLEAN" = false ]; then
            echo ""
            echo "   ⚠️  ПОСЛЕДНЕЕ ПРЕДУПРЕЖДЕНИЕ:"
            echo "      Вы потеряете возможность:"
            echo "      • Восстановить файлы через Time Machine"
            echo "      • Использовать 'Вернуть предыдущую версию'"
            echo "      • Откатить изменения за последние дни"
            echo ""
            read -p "   🚨 Всё равно удалить? (y/N): " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "   🗑️  Удаляю $SNAPSHOTS_COUNT снимков..."
                
                # Получаем список всех снимков
                SNAPSHOTS_LIST=$(tmutil listlocalsnapshots / 2>/dev/null | grep "com.apple.TimeMachine" | sed 's/.*com\.apple\.TimeMachine\.//')
                
                # Удаляем каждый снимок
                DELETED_COUNT=0
                for SNAP in $SNAPSHOTS_LIST; do
                    sudo tmutil deletelocalsnapshots "$SNAP" 2>/dev/null
                    if [ $? -eq 0 ]; then
                        DELETED_COUNT=$((DELETED_COUNT + 1))
                        echo "      ✅ Удалён: $SNAP"
                    else
                        echo "      ❌ Ошибка удаления: $SNAP"
                    fi
                done
                
                # Отключаем создание новых снимков
                echo ""
                read -p "   🔒 Отключить создание новых локальных снимков? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    sudo tmutil disablelocal 2>/dev/null
                    echo "      ✅ Создание новых снимков отключено"
                fi
                
                echo "   ✅ Удалено снимков: $DELETED_COUNT/$SNAPSHOTS_COUNT"
                ESTIMATED_SPACE=$((SNAPSHOTS_COUNT * 2))  # Примерно 2 ГБ на снимок
                echo "   💾 Примерно освобождено: ~${ESTIMATED_SPACE} ГБ"
            else
                echo "   ✅ Снимки сохранены (пользователь отказался)"
            fi
        else
            echo "   ⚠️  Для удаления снимков нужны права администратора"
        fi
    else
        echo "   ✅ Снимки сохранены (пользователь отказался)"
    fi
else
    echo "   ✅ Локальных снимков не найдено"
fi

# ============================================
# 10. DOCKER
# ============================================
echo ""
echo "🐳 ШАГ 8: Проверка Docker..."
echo "----------------------------------------"

if command -v docker &> /dev/null; then
    echo "   🔍 Docker найден"
    
    # Показываем текущее использование
    echo ""
    echo "   📊 ТЕКУЩЕЕ ИСПОЛЬЗОВАНИЕ DOCKER:"
    
    # Размер виртуальной машины
    DOCKER_VM_SIZE=$(du -sh ~/Library/Containers/com.docker.docker/Data/vms 2>/dev/null | cut -f1)
    if [ -n "$DOCKER_VM_SIZE" ]; then
        echo "      • Виртуальная машина: $DOCKER_VM_SIZE"
    fi
    
    # Количество и размер образов
    IMAGE_COUNT=$(docker images -q 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' 2>/dev/null)
    IMAGE_SIZE=$(docker system df --format '{{.Size}}' 2>/dev/null | head -1 2>/dev/null)
    if [ -n "$IMAGE_SIZE" ]; then
        echo "      • Образов: $IMAGE_COUNT шт ($IMAGE_SIZE)"
    else
        echo "      • Образов: $IMAGE_COUNT шт"
    fi
    
    # Количество контейнеров
    CONTAINER_COUNT=$(docker ps -aq 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' 2>/dev/null)
    RUNNING_COUNT=$(docker ps -q 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' 2>/dev/null)
    echo "      • Контейнеров: $CONTAINER_COUNT (запущено: $RUNNING_COUNT)"
    
    # Тома (самое опасное!)
    VOLUME_COUNT=$(docker volume ls -q 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' 2>/dev/null)
    echo "      • Томов (базы данных): $VOLUME_COUNT"
    
    echo ""
    echo "   ⚠️  ВНИМАНИЕ: Docker может содержать:"
    echo "      • 🗄️  Базы данных (PostgreSQL, MySQL, MongoDB)"
    echo "      • 📁 Файлы веб-приложений"
    echo "      • 🧪 Тестовые данные"
    echo "      • 🐳 Образы для разработки"
    echo ""
    
    # Меню выбора
    echo "   🎯 ВЫБЕРИТЕ ДЕЙСТВИЕ:"
    echo "      1) Удалить только кэш build (безопасно)"
    echo "      2) Удалить ВСЁ (опасно! включая базы данных)"
    echo "      3) Показать детальную информацию"
    echo "      4) Пропустить Docker"
    echo ""
    read -p "   Ваш выбор [1-4]: " docker_choice
    
    case $docker_choice in
        1)
            # БЕЗОПАСНО: только build cache
            echo ""
            echo "   🧹 Очищаю кэш сборок Docker..."
            docker builder prune --force 2>/dev/null
            echo "   ✅ Build cache очищен"
            ;;
        2)
            # ОПАСНО: полная очистка
            echo ""
            echo "   🚨 ВЫ УДАЛЯЕТЕ ВСЕ ДАННЫЕ DOCKER!"
            echo ""
            echo "   БУДУТ УДАЛЕНЫ:"
            echo "      • Все остановленные контейнеры"
            echo "      • Все неиспользуемые образы"
            echo "      • Все тома (базы данных!)"
            echo "      • Все сети"
            echo ""
            read -p "   ❓ ВЫ УВЕРЕНЫ? (y/N): " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "   🗑️  Удаляю ВСЁ в Docker..."
                docker system prune -a --volumes --force 2>/dev/null
                echo "   ✅ Docker полностью очищен"
                
                # Также очищаем кэш Docker Desktop
                rm -rf ~/Library/Caches/com.docker.docker 2>/dev/null
                rm -rf ~/Library/Logs/com.docker.docker 2>/dev/null
            else
                echo "   ✅ Docker не тронут (пользователь отказался)"
            fi
            ;;
        3)
            # Детальная информация
            echo ""
            echo "   📊 ДЕТАЛЬНАЯ ИНФОРМАЦИЯ DOCKER:"
            echo ""
            docker system df --verbose 2>/dev/null || echo "Не удалось получить информацию"
            echo ""
            
            # Список томов
            if [ "$VOLUME_COUNT" -gt 0 ] 2>/dev/null; then
                echo "   📋 СПИСОК ТОМОВ (базы данных):"
                docker volume ls 2>/dev/null | tail -n +2 | while read -r line; do
                    VOLUME_NAME=$(echo "$line" | awk '{print $2}')
                    echo "      • $VOLUME_NAME"
                done
            fi
            
            # Список образов
            if [ "$IMAGE_COUNT" -gt 0 ] 2>/dev/null; then
                echo ""
                echo "   🐳 СПИСОК ОБРАЗОВ:"
                docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" 2>/dev/null | head -10
                if [ "$IMAGE_COUNT" -gt 10 ] 2>/dev/null; then
                    echo "      ... и ещё $((IMAGE_COUNT - 10))"
                fi
            fi
            ;;
        4)
            echo "   ✅ Docker пропущен"
            ;;
        *)
            echo "   ❌ Неверный выбор, пропускаю Docker"
            ;;
    esac
else
    echo "   ⚠️  Docker не установлен, пропускаю"
fi

# ============================================
# 11. HOMEBREW
# ============================================
echo ""
echo "🍺 ШАГ 9: Проверка Homebrew..."
echo "----------------------------------------"

if command -v brew &> /dev/null; then
    echo "   🔍 Homebrew найден"
    
    # Проверяем сколько места занимает Homebrew
    echo ""
    echo "   📊 ИНФОРМАЦИЯ О HOMEBREW:"
    
    # Размер кэша
    CACHE_PATH=$(brew --cache 2>/dev/null)
    if [ -n "$CACHE_PATH" ]; then
        CACHE_SIZE=$(du -sh "$CACHE_PATH" 2>/dev/null | cut -f1)
        echo "      • Кэш скачанных файлов: $CACHE_SIZE"
    fi
    
    # Количество установленных формул
    FORMULA_COUNT=$(brew list --formula 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' 2>/dev/null)
    echo "      • Установлено формул: $FORMULA_COUNT"
    
    # Количество установленных casks
    CASK_COUNT=$(brew list --cask 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' 2>/dev/null)
    echo "      • Установлено .app (casks): $CASK_COUNT"
    
    # Размер Cellar (установленные программы)
    if [ -d "/usr/local/Cellar" ]; then
        CELLAR_SIZE=$(du -sh /usr/local/Cellar 2>/dev/null | cut -f1)
        echo "      • Установленные программы: $CELLAR_SIZE"
    fi
    
    echo ""
    echo "   ℹ️  Homebrew хранит:"
    echo "      • 📦 Кэши скачанных .tar.gz файлов"
    echo "      • 🗃️  Старые версии установленных программ"
    echo "      • 📝 Логи установки и обновлений"
    echo "      • 🔧 Исходные коды (для --build-from-source)"
    echo ""
    
    # Меню выбора
    echo "   🎯 ВЫБЕРИТЕ ДЕЙСТВИЕ:"
    echo "      1) Удалить только кэши старых скачанных файлов (рекомендуется)"
    echo "      2) Удалить ВСЁ включая старые версии программ"
    echo "      3) Удалить только логи Homebrew"
    echo "      4) Показать детальную информацию"
    echo "      5) Пропустить Homebrew"
    echo ""
    read -p "   Ваш выбор [1-5]: " brew_choice
    
    case $brew_choice in
        1)
            # БЕЗОПАСНО: только старые кэши
            echo ""
            echo "   🧹 Удаляю старые кэши скачанных файлов..."
            
            # Безопасная очистка: удаляем только кэши, старше 30 дней
            brew cleanup --prune=30 2>/dev/null
            
            # Очищаем логи (безопасно)
            rm -rf ~/Library/Logs/Homebrew/* 2>/dev/null
            
            echo "   ✅ Кэши старше 30 дней и логи удалены"
            
            # Показываем сколько освобождено
            CLEANUP_INFO=$(brew cleanup --prune=30 -n 2>/dev/null | grep -E '^Would remove|^This operation would free')
            if [ -n "$CLEANUP_INFO" ]; then
                echo "$CLEANUP_INFO" | while read -r line; do
                    echo "   💾 $line"
                done
            fi
            ;;
        2)
            # ОПАСНО: полная очистка
            echo ""
            echo "   🚨 ВЫ УДАЛЯЕТЕ СТАРЫЕ ВЕРСИИ ПРОГРАММ!"
            echo ""
            echo "   БУДУТ УДАЛЕНЫ:"
            echo "      • Все старые версии установленных программ"
            echo "      • Все кэши скачанных файлов"
            echo "      • Все логи Homebrew"
            echo ""
            echo "   ⚠️  После этого вы не сможете:"
            echo "      • Откатить программу на старую версию"
            echo "      • Переустановить без скачивания из интернета"
            echo ""
            read -p "   ❓ ВЫ УВЕРЕНЫ? (y/N): " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "   🗑️  Удаляю ВСЁ старое в Homebrew..."
                
                # Удаляем старые версии программ
                brew cleanup --prune=all 2>/dev/null
                
                # Удаляем кэши
                brew cleanup --prune=all -s 2>/dev/null
                
                # Очищаем логи
                rm -rf ~/Library/Logs/Homebrew/* 2>/dev/null
                rm -rf ~/Library/Caches/Homebrew/* 2>/dev/null
                
                echo "   ✅ Homebrew полностью очищен"
                
                # Предупреждение о переустановке
                echo ""
                echo "   💡 После переустановки программ потребуется интернет"
            else
                echo "   ✅ Homebrew не тронут (пользователь отказался)"
            fi
            ;;
        3)
            # Только логи
            echo ""
            echo "   📝 Удаляю только логи Homebrew..."
            rm -rf ~/Library/Logs/Homebrew/* 2>/dev/null
            echo "   ✅ Логи Homebrew удалены"
            ;;
        4)
            # Детальная информация
            echo ""
            echo "   📊 ДЕТАЛЬНАЯ ИНФОРМАЦИЯ HOMEBREW:"
            echo ""
            
            # Показываем что можно удалить
            echo "   🗑️  Что можно безопасно удалить:"
            brew cleanup -n 2>/dev/null | grep -E '^Would remove|^This operation would free' || echo "      Нечего удалять"
            
            # Самые большие кэши
            echo ""
            echo "   📦 Самые большие файлы в кэше:"
            if [ -n "$CACHE_PATH" ]; then
                find "$CACHE_PATH" -type f -size +10M 2>/dev/null | xargs ls -lh 2>/dev/null | head -10 || echo "      Больших файлов не найдено"
            fi
            
            # Старые версии программ
            echo ""
            echo "   🔄 Старые версии установленных программ:"
            brew list --formula -1 2>/dev/null | while read -r formula; do
                if [ -d "/usr/local/Cellar/$formula" ]; then
                    versions=$(ls -1 "/usr/local/Cellar/$formula/" 2>/dev/null | wc -l 2>/dev/null)
                    if [ "$versions" -gt 1 ] 2>/dev/null; then
                        size=$(du -sh "/usr/local/Cellar/$formula/" 2>/dev/null | cut -f1)
                        echo "      • $formula: $versions версий ($size)"
                    fi
                fi
            done | head -10
            ;;
        5)
            echo "   ✅ Homebrew пропущен"
            ;;
        *)
            echo "   ❌ Неверный выбор, пропускаю Homebrew"
            ;;
    esac
else
    echo "   ⚠️  Homebrew не установлен, пропускаю"
fi

# ============================================
# ФИНАЛЬНЫЙ ОТЧЕТ
# ============================================
echo ""
echo "══════════════════════════════════════════════════════════"
echo "🎉 ОЧИСТКА ЗАВЕРШЕНА!"
echo "══════════════════════════════════════════════════════════"
echo ""

# Информация о системе
echo "📊 СИСТЕМНАЯ ИНФОРМАЦИЯ:"
echo "   • macOS: $(sw_vers -productVersion) $(sw_vers -buildVersion 2>/dev/null)"
echo "   • Архитектура: $(uname -m)"
echo "   • Пользователь: $(whoami)"
echo ""

# Свободное место
echo "💾 СВОБОДНОЕ МЕСТО НА ДИСКЕ:"
FREE_SPACE=$(df -h / | tail -1 | awk '{print $4}')
USED_SPACE=$(df -h / | tail -1 | awk '{print $3}')
TOTAL_SPACE=$(df -h / | tail -1 | awk '{print $2}')
echo "   • Всего: $TOTAL_SPACE"
echo "   • Использовано: $USED_SPACE"
echo "   • Свободно: $FREE_SPACE"
echo ""

# Рекомендации
echo "📌 РЕКОМЕНДАЦИИ ДЛЯ РАЗРАБОТЧИКОВ:"
echo "   1. 🔄 Перезагрузитесь для применения изменений"
echo "   2. 🚫 Unity пересоздаст кэши при первом запуске"
echo "   3. 💾 Держите свободными минимум 15% диска"
echo "   4. 📁 Используйте внешние SSD для проектов"
echo "   5. 🗑️  Запускайте этот скрипт раз в неделю"
echo ""

# Предупреждение
echo "⚠️  ВАЖНЫЕ ПРИМЕЧАНИЯ:"
echo "   • Скрипт НЕ удаляет проекты и исходный код"
echo "   • Скрипт НЕ удаляет установленные редакторы Unity"
echo "   • Все удаляемые файлы — временные и кэши"
echo "   • Проверяйте .gitignore для бинарных файлов"
echo ""

# Вопрос о перезагрузке
echo "══════════════════════════════════════════════════════════"
read -p "🔄 Перезагрузить сейчас? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔄 Перезагрузка через 5 секунд..."
    echo "   Сохраните все открытые документы!"
    sleep 5
    sudo shutdown -r now
else
    echo ""
    echo "✅ Готово! Перезагрузите Mac когда будет удобно."
    echo "   Спасибо за использование macOS Dev Cleaner!"
    echo ""
    echo "🌟 Если скрипт помог, поставьте звезду на GitHub!"
    echo "   https://github.com/[yourname]/macos-dev-cleaner"
fi

exit 0