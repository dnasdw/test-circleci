::  input:
::      %1 {vs2008|vs2010|vs2012|vs2013|vs2015|vs2017|vs2019}
::      %2 {devenv|nmake}
::      %3 {x86_32|x86_64}
::      %4 {Debug|Release|RelWithDebInfo|MinSizeRel}
::      %5 {winxp|win7}
::          only for vs2012/vs2013/vs2015/vs2017
::      %6 [target]
::          for example "install"

::  var:
::      %VCVARSALL%
::          only for nmake
::      %CMAKE_BUILD_TYPE%
::      %GENERATOR%
::      %TOOLSET%
::      %PLATFORM%
::          only for vs2019
::      %TARGET%

SET

FOR /?

IF NOT "%~1"=="vs2008" (
    IF NOT "%~1"=="vs2010" (
        IF NOT "%~1"=="vs2012" (
            IF NOT "%~1"=="vs2013" (
                IF NOT "%~1"=="vs2015" (
                    IF NOT "%~1"=="vs2017" (
                        IF NOT "%~1"=="vs2019" (
                            GOTO ERROR
                        )
                    )
                )
            )
        )
    )
)

IF NOT "%~2"=="devenv" (
    IF NOT "%~2"=="nmake" (
        GOTO ERROR
    )
)

IF NOT "%~3"=="x86_32" (
    IF NOT "%~3"=="x86_64" (
        GOTO ERROR
    )
)

IF NOT "%~4"=="Debug" (
    IF NOT "%~4"=="Release" (
        IF NOT "%~4"=="RelWithDebInfo" (
            IF NOT "%~4"=="MinSizeRel" (
                GOTO ERROR
            )
        )
    )
)

IF NOT "%~5"=="winxp" (
    IF NOT "%~5"=="win7" (
        GOTO ERROR
    )
)

GOTO :EOF

:ERROR
EXIT /B 1
GOTO :EOF
