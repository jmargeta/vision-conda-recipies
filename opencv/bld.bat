mkdir build
cd build

set PY_VER_NO_DOT=%PY_VER:.=%

cmake ^
    -G "Visual Studio 9 2008 Win64" ^
    -DPYTHON_EXECUTABLE:FILEPATH="%PYTHON%" ^
    -DPYTHON_INCLUDE_PATH:PATH="%PREFIX%/include" ^
    -DPYTHON_LIBRARY:FILEPATH="%PREFIX%/libs/python%PY_VER_NO_DOT%.lib" ^
    -DPYTHON_PACKAGES_PATH:PATH="%SP_DIR%" ^
    -DVISUAL_STUDIO_PATH:STRING="%VCINSTALLDIR%" ^
    -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
    -DBUILD_SHARED_LIBS:BOOL=OFF ^
    -DWITH_CUDA:BOOL=OFF ^
    "%SRC_DIR%" 

cmake --build . --config Release
cmake --build . --target install --config Release

if errorlevel 1 exit 1
