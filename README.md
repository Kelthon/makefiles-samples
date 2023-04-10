# Makefiles samples

This repo contains templates of makefiles to compile C/C++ source files using MinGW

## Getting started

To compile your C/C++ code using Makefile you should be copy the template on `<project-dir>`. You can modify the variables and recipes to better compile your code or project and to invoke the `mingw32-make` or `make` using a recipe.

To build and run a simple file you can use the target `%.exe` writing the basename of file with `.exe` suffix. This target will do with the make compiling and, if no have problems in compilation, run the file. For example to build and execute a OpenGl program, that draw a triangle in the screen, named `triangle.c`, you can use `triangle.exe`

```sh
cp .\Makefile <project-dir>
mingw32-make triangle.exe
```

Output:
!["Program Output: OpenGL Triangle"](./public/triangle.png "Output: OpenGL Triangle")

### On windows

On Windows you should be use `mingw32-make` to compile program or project. Or you can use a batch script to call `mingw32-make.exe` with alias `make`, like e Linux systems. For this you should be copy a `make.bat` on MinGw binaries folder `<MinGw-dir>/bin`.

```sh
cp .\make.bat C:/MinGw/bin
make template-version
```

```sh
>> mingw32-make template-version
>> v2.0.0
```

### On linux

The makefile template went project to be executed in Windows systems by MinGw, It should be compatible with Linux system using directly `make`, however if necessary you can customize the recipes to use native fuctions of Linux.

```Makefile
# Makefile
custom-recipe:
    INPUT = ""
    read INPUT
    if [$(INPUT) == "main.c"]; then \
        $(CC) $(INPUT) -o program.exe; \
        ./program.exe; \
    else \
        @echo "Not found"
    fi

```

```sh
make custom-recipe
```

```sh
>> main.c
>> Hello World!
```

## How to use

To compile you project or file you should be to call a any recipe

### Recipes

#### run

#### build

#### cbuild

#### compile

#### clean

#### template-version

#### %.o

#### %.exe

### Customizing

You can customize the compilation proccess change or alter variables and recipes on Makefile

#### Program

##### APPNAME

##### TARGET

#### C Compiler

##### CC

##### CC_STD

##### CFLAGS

#### CPP Compiler

##### CXX

##### CXX_STD

##### CXXFLAGS

### FLAGS

#### OPTIONAL_CFLAGS

#### EXTRA_CFLAGS

#### INCLUDE_CFLAGS

### Directories

#### BIN_DIR

#### SRC_DIR

#### OBJ_DIR

#### LIB_DIR

#### INCLUDE_DIR

### Others

#### RM

#### HEADER_FILES

#### SOURCE_FILES

#### HXX_FILES

#### OBJ_FILES

#### C_OBJ

#### OBJ
