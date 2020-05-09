::  input:
::      %ARGS1% %1 {vs2008|vs2010|vs2012|vs2013|vs2015|vs2017|vs2019}
::      %ARGS2% %2 {devenv|nmake}
::      %ARGS3% %3 {x86_32|x86_64}
::      %ARGS4% %4 {Debug|Release|RelWithDebInfo|MinSizeRel}
::      %ARGS5% %5 {winxp|win7}
::          only for vs2012/vs2013/vs2015/vs2017 devenv
::      %ARGS6% %6 [target]
::          for example "install"

::  var:
::      %CMAKE_BUILD_TYPE%
::      %GENERATOR%
::      %TOOLSET%
::          only for vs2012/vs2013/vs2015/vs2017/vs2019 devenv
::      %PLATFORM%
::          only for vs2019 devenv
::      %TARGET%
::      %VCVARSALL%
::          only for nmake
::      %ARCH%
::          only for nmake

SET ARGS1=%~1
SET ARGS2=%~2
SET ARGS3=%~3
SET ARGS4=%~4
SET ARGS5=%~5
SET ARGS6=%~6

IF NOT "%ARGS1%"=="vs2008" (
    IF NOT "%ARGS1%"=="vs2010" (
        IF NOT "%ARGS1%"=="vs2012" (
            IF NOT "%ARGS1%"=="vs2013" (
                IF NOT "%ARGS1%"=="vs2015" (
                    IF NOT "%ARGS1%"=="vs2017" (
                        IF NOT "%ARGS1%"=="vs2019" (
                            GOTO ERROR
                        )
                    )
                )
            )
        )
    )
)

IF NOT "%ARGS2%"=="devenv" (
    IF NOT "%ARGS2%"=="nmake" (
        GOTO ERROR
    )
)

IF NOT "%ARGS3%"=="x86_32" (
    IF NOT "%ARGS3%"=="x86_64" (
        GOTO ERROR
    )
)

IF NOT "%ARGS4%"=="Debug" (
    IF NOT "%ARGS4%"=="Release" (
        IF NOT "%ARGS4%"=="RelWithDebInfo" (
            IF NOT "%ARGS4%"=="MinSizeRel" (
                GOTO ERROR
            )
        )
    )
)

IF NOT "%ARGS5%"=="winxp" (
    IF NOT "%ARGS5%"=="win7" (
        GOTO ERROR
    )
)

SET CMAKE_BUILD_TYPE=%ARGS4%

SET TARGET=%ARGS6%

IF "%ARGS2%"=="devenv" (
    IF "%ARGS3%"=="x86_32" (
        SET PLATFORM=Win32
    ) ELSE IF "%ARGS3%"=="x86_64" (
        SET PLATFORM=x64
    )

    IF "%ARGS1%"=="vs2008" (
        IF "%PLATFORM%"=="Win32" (
            SET GENERATOR="Visual Studio 9 2008"
        ) ELSE IF "%PLATFORM%"=="x64" (
            SET GENERATOR="Visual Studio 9 2008 Win64"
        )
    ) ELSE IF "%ARGS1%"=="vs2010" (
        IF "%PLATFORM%"=="Win32" (
            SET GENERATOR="Visual Studio 10"
        ) ELSE IF "%PLATFORM%"=="x64" (
            SET GENERATOR="Visual Studio 10 Win64"
        )
    ) ELSE IF "%ARGS1%"=="vs2012" (
        IF "%PLATFORM%"=="Win32" (
            SET GENERATOR="Visual Studio 11"
        ) ELSE IF "%PLATFORM%"=="x64" (
            SET GENERATOR="Visual Studio 11 Win64"
        )
        IF "%ARGS5%"=="xp" (
            SET TOOLSET=v110_xp
        ) ELSE (
            SET TOOLSET=v110
        )
    ) ELSE IF "%ARGS1%"=="vs2013" (
        IF "%PLATFORM%"=="Win32" (
            SET GENERATOR="Visual Studio 12"
        ) ELSE IF "%PLATFORM%"=="x64" (
            SET GENERATOR="Visual Studio 12 Win64"
        )
        IF "%ARGS5%"=="xp" (
            SET TOOLSET=v120_xp
        ) ELSE (
            SET TOOLSET=v120
        )
    ) ELSE IF "%ARGS1%"=="vs2015" (
        IF "%PLATFORM%"=="Win32" (
            SET GENERATOR="Visual Studio 14"
        ) ELSE IF "%PLATFORM%"=="x64" (
            SET GENERATOR="Visual Studio 14 Win64"
        )
        IF "%ARGS5%"=="xp" (
            SET TOOLSET=v140_xp
        ) ELSE (
            SET TOOLSET=v140
        )
    ) ELSE IF "%ARGS1%"=="vs2017" (
        IF "%PLATFORM%"=="Win32" (
            SET GENERATOR="Visual Studio 15"
        ) ELSE IF "%PLATFORM%"=="x64" (
            SET GENERATOR="Visual Studio 15 Win64"
        )
        IF "%ARGS5%"=="xp" (
            SET TOOLSET=v141_xp
        ) ELSE (
            SET TOOLSET=v141
        )
    ) ELSE IF "%ARGS1%"=="vs2019" (
        SET GENERATOR="Visual Studio 16"
        SET TOOLSET=v142
    )

    MKDIR build
    PUSHD build
    IF "%ARGS1%"=="vs2008" (
        cmake -G "%GENERATOR%" .. || (
            POPD
            GOTO ERROR
        )
    ) ELSE IF "%ARGS1%"=="vs2010" (
        cmake -G "%GENERATOR%" .. || (
            POPD
            GOTO ERROR
        )
    ) ELSE IF "%ARGS1%"=="vs2012" (
        cmake -G "%GENERATOR%" -T %TOOLSET% .. || (
            POPD
            GOTO ERROR
        )
    ) ELSE IF "%ARGS1%"=="vs2013" (
        cmake -G "%GENERATOR%" -T %TOOLSET% .. || (
            POPD
            GOTO ERROR
        )
    ) ELSE IF "%ARGS1%"=="vs2015" (
        cmake -G "%GENERATOR%" -T %TOOLSET% .. || (
            POPD
            GOTO ERROR
        )
    ) ELSE IF "%ARGS1%"=="vs2017" (
        cmake -G "%GENERATOR%" -T %TOOLSET% .. || (
            POPD
            GOTO ERROR
        )
    ) ELSE IF "%ARGS1%"=="vs2019" (
        cmake -G "%GENERATOR%" -T %TOOLSET% -A %PLATFORM% .. || (
            POPD
            GOTO ERROR
        )
    )
    IF "%TARGET%"=="" (
        cmake --build . --config %CMAKE_BUILD_TYPE% --clean-first || (
            POPD
            GOTO ERROR
        )
    ) ELSE (
        cmake --build . --target "%TARGET%" --config %CMAKE_BUILD_TYPE% --clean-first || (
            POPD
            GOTO ERROR
        )
    )
    POPD
) ELSE IF "%ARGS2%"=="nmake" (
    IF "%ARGS1%"=="vs2008" (
        IF DEFINED VS90COMNTOOLS (
            SET VCVARSALL="%VS90COMNTOOLS%..\..\VC\vcvarsall.bat"
        }
    ) ELSE IF "%ARGS1%"=="vs2010" (
        IF DEFINED VS100COMNTOOLS (
            SET VCVARSALL="%VS100COMNTOOLS%..\..\VC\vcvarsall.bat"
        )
    ) ELSE IF "%ARGS1%"=="vs2012" (
        IF DEFINED VS110COMNTOOLS (
            SET VCVARSALL="%VS110COMNTOOLS%..\..\VC\vcvarsall.bat"
        )
    ) ELSE IF "%ARGS1%"=="vs2013" (
        IF DEFINED VS120COMNTOOLS (
            SET VCVARSALL="%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
        )
    ) ELSE IF "%ARGS1%"=="vs2015" (
        IF DEFINED VS140COMNTOOLS (
            SET VCVARSALL="%VS140COMNTOOLS%..\..\VC\vcvarsall.bat"
        )
    ) ELSE IF "%ARGS1%"=="vs2017" (
        FOR /F "tokens=1,2,*" %%I IN ('REG QUERY HKLM\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7 /v 15.0 ^| FINDSTR "15.0"') DO (
            SET VCVARSALL="%%~KVC\Auxiliary\Build\vcvarsall.bat"
        )
    ) ELSE IF "%ARGS1%"=="vs2019" (
        FOR /F %%I IN ('REG QUERY HKLM\SOFTWARE\WOW6432Node\Microsoft ^| FINDSTR "VisualStudio_"') DO (
            CALL :FINDVS "%%~I" 2019
        )
    )
    IF NOT DEFINED VCVARSALL (
        GOTO ERROR
    )

    IF "%ARGS3%"=="x86_32" (
        SET ARCH=x86
    ) ELSE IF "%ARGS3%"=="x86_64" (
        SET ARCH=amd64
    )

    CALL %VCVARSALL% %ARCH%

    MKDIR build
    PUSHD build
    cmake -DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% -G "NMake Makefiles" .. || (
        POPD
        GOTO ERROR
    )
    IF "%TARGET%"=="" (
        cmake --build . --config %CMAKE_BUILD_TYPE% --clean-first || (
            POPD
            GOTO ERROR
        )
    ) ELSE (
        cmake --build . --target "%TARGET%" --config %CMAKE_BUILD_TYPE% --clean-first || (
            POPD
            GOTO ERROR
        )
    )
    POPD
)

GOTO :EOF

:FINDVS
SET vsid=%~1
SET vsid=%vsid:~63%
REG QUERY %~1\Capabilities | FINDSTR /R "ApplicationName.*REG_SZ.*Microsoft.Visual.Studio.%~2" && FOR /F "tokens=1,2,*" %%I IN ('REG QUERY HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%vsid% ^| FINDSTR "InstallLocation"') DO (
    SET VCVARSALL="%%~K\VC\Auxiliary\Build\vcvarsall.bat"
)
GOTO :EOF

:ERROR
EXIT /B 1
GOTO :EOF
