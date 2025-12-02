@echo off
setlocal enabledelayedexpansion

:: Script para verificar alinhamento ELF de bibliotecas nativas (16 KB) - Windows
:: Uso: verificar-16kb-windows.bat [caminho_do_aab]

:: ------------------- CONFIGURAÇÃO NECESSÁRIA -------------------
:: Ajuste o caminho abaixo para apontar para o seu llvm-readelf.exe
:: Ele fica dentro da pasta do NDK que você instalou.

set NDK_VERSION=27.0.12077973
set READELF=%LOCALAPPDATA%\Android\Sdk\ndk\%NDK_VERSION%\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-readelf.exe

:: Se o caminho acima não funcionar, ajuste manualmente:
:: set READELF="C:\Users\<SEU_USUARIO>\AppData\Local\Android\Sdk\ndk\<NDK_VERSION>\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-readelf.exe"
:: <SEU_USUARIO> = O nome do seu usuário no Windows.
:: <NDK_VERSION> = A versão do NDK que você está usando (ex: 27.0.12077973).

:: Verificar se o arquivo existe
if not exist "%READELF%" (
    echo ❌ Erro: llvm-readelf.exe não encontrado em:
    echo    %READELF%
    echo.
    echo 💡 Ajuste o caminho no script ou instale o Android NDK
    pause
    exit /b 1
)

:: Define o caminho do AAB (ou usa o padrão)
if "%~1"=="" (
    set AAB_PATH=build\app\outputs\bundle\release\app-release.aab
) else (
    set AAB_PATH=%~1
)

:: Verificar se o AAB existe
if not exist "%AAB_PATH%" (
    echo ❌ AAB não encontrado: %AAB_PATH%
    pause
    exit /b 1
)

:: Define o nome do arquivo de saída
set OUTPUT=relatorio_alinhamento.txt

echo 🔍 Verificando alinhamento ELF de bibliotecas nativas...
echo 📦 AAB: %AAB_PATH%
echo 📄 Relatório será salvo em: %OUTPUT%
echo.

:: Criar diretório temporário para extrair AAB
set TEMP_DIR=%TEMP%\aab_check_%RANDOM%
mkdir "%TEMP_DIR%" 2>nul

:: Extrair AAB
echo 📂 Extraindo AAB...
powershell -Command "Expand-Archive -Path '%AAB_PATH%' -DestinationPath '%TEMP_DIR%' -Force" 2>nul
if errorlevel 1 (
    echo ❌ Erro ao extrair AAB
    pause
    exit /b 1
)

:: Inicializar contadores
set /a INCOMPATIBLE_COUNT=0
set /a COMPATIBLE_COUNT=0
set /a TOTAL_COUNT=0

:: Criar arquivo de relatório
(
    echo ============================================================
    echo RELATÓRIO DE ALINHAMENTO ELF - COMPATIBILIDADE 16 KB
    echo ============================================================
    echo Data: %DATE% %TIME%
    echo AAB: %AAB_PATH%
    echo Ferramenta: %READELF%
    echo.
) > "%OUTPUT%"

:: Verificar cada ABI
for %%A in (arm64-v8a armeabi-v7a x86_64 x86) do (
    set LIBPATH=%TEMP_DIR%\base\lib\%%A
    
    if exist "!LIBPATH!" (
        echo.
        echo ============================================================
        echo 📚 Verificando bibliotecas em: %%A
        echo ============================================================
        echo.
        
        (
            echo.
            echo ============================================================
            echo ABI: %%A
            echo ============================================================
        ) >> "%OUTPUT%"
        
        :: Processar cada arquivo .so
        for %%F in ("!LIBPATH!\*.so") do (
            set /a TOTAL_COUNT+=1
            set FILENAME=%%~nxF
            
            echo 🔍 Analisando: !FILENAME!
            
            (
                echo.
                echo ============================================================
                echo Analisando: !FILENAME!
                echo ============================================================
            ) >> "%OUTPUT%"
            
            :: Executar llvm-readelf e verificar alinhamento
            "%READELF%" -l "%%F" | findstr "LOAD" >> "%OUTPUT%"
            
            :: Verificar se o alinhamento é >= 16 KB (16384 bytes)
            for /f "tokens=*" %%L in ('"%READELF%" -l "%%F" ^| findstr "LOAD"') do (
                :: Extrair o último campo (alinhamento em hex)
                for /f "tokens=7" %%X in ("%%L") do (
                    set ALIGNMENT=%%X
                    
                    :: Converter hex para decimal (simplificado - verifica se começa com 0x4 ou maior)
                    echo !ALIGNMENT! | findstr /R "^0x[4-9a-fA-F]" >nul
                    if !errorlevel! equ 0 (
                        echo    ✅ Compatível ^(alinhamento: !ALIGNMENT!^)
                        set /a COMPATIBLE_COUNT+=1
                        (
                            echo STATUS: ✅ COMPATÍVEL
                            echo Alinhamento: !ALIGNMENT! ^(>= 16 KB^)
                        ) >> "%OUTPUT%"
                    ) else (
                        echo    ❌ INCOMPATÍVEL ^(alinhamento: !ALIGNMENT!^)
                        set /a INCOMPATIBLE_COUNT+=1
                        (
                            echo STATUS: ❌ INCOMPATÍVEL
                            echo Alinhamento: !ALIGNMENT! ^(< 16 KB^)
                        ) >> "%OUTPUT%"
                    )
                )
            )
        )
    )
)

:: Resumo final
echo.
echo ============================================================
echo 📊 RESUMO:
echo    📦 Total de bibliotecas: %TOTAL_COUNT%
echo    ✅ Compatíveis: %COMPATIBLE_COUNT%
echo    ❌ Incompatíveis: %INCOMPATIBLE_COUNT%
echo ============================================================
echo.

(
    echo.
    echo ============================================================
    echo RESUMO FINAL
    echo ============================================================
    echo Total de bibliotecas analisadas: %TOTAL_COUNT%
    echo Bibliotecas compatíveis ^(>= 16 KB^): %COMPATIBLE_COUNT%
    echo Bibliotecas incompatíveis ^(< 16 KB^): %INCOMPATIBLE_COUNT%
    echo.
) >> "%OUTPUT%"

if %INCOMPATIBLE_COUNT% gtr 0 (
    echo ⚠️  ATENÇÃO: %INCOMPATIBLE_COUNT% biblioteca^(s^) incompatível^(is^) encontrada^(s^)
    echo.
    echo 💡 SOLUÇÕES:
    echo    1. Atualize os plugins Flutter para versões mais recentes
    echo    2. Verifique se os plugins suportam 16 KB
    echo    3. Entre em contato com os mantenedores dos plugins
    echo.
    echo 📄 Relatório completo salvo em: %OUTPUT%
    pause
    exit /b 1
) else (
    echo ✅ Todas as bibliotecas são compatíveis com 16 KB!
    echo.
    echo 📄 Relatório completo salvo em: %OUTPUT%
    pause
    exit /b 0
)

:: Limpar diretório temporário
rmdir /s /q "%TEMP_DIR%" 2>nul

