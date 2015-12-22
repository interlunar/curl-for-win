:: Copyright 2015 Viktor Szakats <https://github.com/vszakats>
:: See LICENSE.md

@echo off

set _NAM=%~n0
set _NAM=%_NAM:~3%
set _VER=%1
set _CPU=%2

setlocal
set _CDO=%CD%
pushd "%_NAM%"

:: Build

del /s *.o *.a *.lo *.la *.lai *.Plo *.pc >> nul 2>&1
if "%_CPU%" == "win32" set LDFLAGS=-m32
if "%_CPU%" == "win64" set LDFLAGS=-m64
set CFLAGS=%LDFLAGS% -U__STRICT_ANSI__ -I"%_CDO:\=/%/libev/include" -L"%_CDO:\=/%/libev/lib"
set CXXFLAGS=%CFLAGS%
:: Open dummy file descriptor to fix './<script>: line <n>: 0: Bad file descriptor'
sh -c "exec 0</dev/null && ./configure '--prefix=%CD:\=/%'"
sh -c "exec 0</dev/null && mingw32-make MAKE=C:/w/mingw64/bin/mingw32-make"
sh -c "exec 0</dev/null && mingw32-make MAKE=C:/w/mingw64/bin/mingw32-make install"

:: Make steps for determinism

if exist lib\*.a strip -p --enable-deterministic-archives -g lib\*.a

touch -c lib/*.a -r ChangeLog

popd
endlocal
