rem PyBuffer submodule to allow conversion of images to numpy arrays
git clone git://github.com/jmargeta/itkPyBuffer.git ./Modules/External/itkPyBuffer

rem NUMPY include dirs
for /f %%i in ('python -c "import numpy; import os; print(os.path.join(numpy.get_include(), 'numpy'))"') do set NP_INCLUDE=%%i

mkdir build
cd build

set PY_VER_NO_DOT=%PY_VER:.=%

cmake ^
    -G "Visual Studio 9 2008 Win64" ^
    -DPYTHON_EXECUTABLE:FILEPATH="%PYTHON%" ^
    -DPYTHON_INCLUDE_DIR:PATH="%PREFIX%/include" ^
    -DPYTHON_LIBRARY:FILEPATH="%PREFIX%/libs/python%PY_VER_NO_DOT%.lib" ^
    -DPY_SITE_PACKAGES_PATH:PATH="%SP_DIR%" ^
	-DPYTHON_NUMARRAY_INCLUDE_DIR:PATH="%NP_INCLUDE%" ^
    -DBUILD_EXAMPLES:BOOL=OFF ^
	-DBUILD_TESTING:BOOL=OFF ^
    -DITK_WRAP_PYTHON:BOOL=ON ^
	-DITK_BUILD_DEFAULT_MODULES:BOOL=ON ^
	-DModule_ITKPyBuffer:BOOL=ON ^
	-DModule_ITKBufferConvertion:BOOL=ON ^
	-DModule_ITKReview:BOOL=ON ^
    -DITK_WRAP_DIMS:STRING=2;3;4 ^
	-DITK_WRAP_complex_double:BOOL=OFF ^
	-DITK_WRAP_complex_float:BOOL=OFF ^
	-DITK_WRAP_covariant_vector_double:BOOL=OFF ^
	-DITK_WRAP_covariant_vector_float:BOOL=ON ^
	-DITK_WRAP_double:BOOL=OFF ^
	-DITK_WRAP_float:BOOL=ON ^
	-DITK_WRAP_rgb_unsigned_char:BOOL=OFF ^
	-DITK_WRAP_rgb_unsigned_short:BOOL=OFF ^
	-DITK_WRAP_rgba_unsigned_char:BOOL=OFF ^
	-DITK_WRAP_rgba_unsigned_short:BOOL=OFF ^
	-DITK_WRAP_signed_char:BOOL=OFF ^
	-DITK_WRAP_signed_long:BOOL=OFF ^
	-DITK_WRAP_signed_short:BOOL=ON ^
	-DITK_WRAP_unsigned_char:BOOL=ON ^
	-DITK_WRAP_unsigned_long:BOOL=ON ^
	-DITK_WRAP_unsigned_short:BOOL=OFF ^
	-DITK_WRAP_vector_double:BOOL=OFF ^
	-DITK_WRAP_vector_float:BOOL=ON ^
	-DINSTALL_WRAP_ITK_COMPATIBILITY:BOOL=OFF ^
    -DVISUAL_STUDIO_PATH:STRING="%VCINSTALLDIR%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    "%SRC_DIR%" 

rem Configure and install
cmake --build . --config Release
cmake --build . --target install --config Release

rem Copy built files to the itk folder
mkdir %SP_DIR%\itk
mkdir %SP_DIR%\itk\itkExtras
mkdir %SP_DIR%\itk\Configuration
copy .\lib\*.py %SP_DIR%\itk
copy .\lib\Release\* %SP_DIR%\itk
copy .\bin\Release\* %SP_DIR%\itk
copy .\Wrapping\Generators\Python\Release\* %SP_DIR%\itk
copy .\Wrapping\Generators\Python\itkExtras\*.py %SP_DIR%\itk\itkExtras
copy .\Wrapping\Generators\Python\Configuration %SP_DIR%\itk\Configuration


rem To avoid the need for admin privileges needed for the cmake install
rem and to avoid hardcoded absolute paths we do two steps:

rem 1. Modify the config paths
python %RECIPE_DIR%\fixItkConfig.py %SP_DIR%\itk\itkConfig.py


rem 2. Make a WrapITK.pth file that gives a relative path to the package
rem could possibly point to the LIBRARY_PREFIX and avoid file copies
echo itk > %SP_DIR%\WrapITK.pth
 
if errorlevel 1 exit 1
