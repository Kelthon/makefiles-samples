# Makefile to compile C/C++ with MinGw
# author: KLT
# date: 2023/03/09

# Defines program target and name
appname 		:= main 
target			:= main.c

# Define compiler and compiler target
cc 				:= gcc
cxx				:= g++
cc_std 			:= -std=c11
cxx_std			:= -std=c++17

# Define a extra flags and diretives for compilation
extra_cflags 	:= -fopenmp 

# Define directories
bin_dir 		:= ./bin
src_dir 		:= ./src
obj_dir 		:= ./obj
lib_dir 		:= ./lib
include_dir 	:= ./include

# Define compiler flags
optional_cflags := -Wextra -Wall
include_cflags := -I $(include_dir)
cflags := $(cc_std) $(optional_cflags) $(extra_cflags) $(include_cflags)
cxxflags := $(cxx_std) $(optional_cflags) $(extra_cflags) $(include_cflags)

# Define all source files and obj files
c_files = $(wildcard $(src_dir)/*.c) $(wildcard *.c) 
cxx_files = $(wildcard $(src_dir)/*.cpp) $(wildcard *.cpp) 
source_files = $(c_files) $(cxx_files)
obj_files = $(patsubst $(src_dir)/%.c, $(obj_dir)/%.o, $(source_files)) $(wildcard *.o)

# Define RM command 
rm := rm -fr

# Define Recipes
.PHONY: all run build compile clean %.o t

t:
	@echo "c: $(c_files)"
	@echo "cpp: $(cxx_files)" 
	@echo "src: $(source_files)"
	@echo "obj: $(obj_files)"
# Build and runs the app
all: build run

# Run the app 
run: $(wildcard $(bin_dir)/$(appname))
	$(bin_dir)/$(appname)

# Build the app adding statics libs
build: compile
	$(cxx) $(cxxflags) $(target) -o $(appname) $(obj_files)

# Compile all source files
compile: $(obj_files) clean

# Remove all binaries
clean:
	@$(rm) $(bin_dir) $(obj_dir)

# Compile a static lib expecifying full path to compilation if exists a source code and a header file
%.o: %.c
	@mkdir -p $(obj_dir);
	$(cc) $(cflags) -c $< -o $@

# Compile a static lib in obj folder if exists the source code is in source folder and header file is in include folder
%.o: $(src_dir)/%.c
	@mkdir -p $(obj_dir);
	$(cc) $(cflags) -c $< -o $(obj_dir)/$(notdir $@)

# Compiles and run a source file expecifying full path to compilation
%.exe: %.c clean
	$(cc) $(cflags) -o $(basename $@) $<
	$(basename $@)

# Compile and run a source file if the file is inside source folder
%.exe: $(src_dir)/%.c clean
	@mkdir -p $(bin_dir);
	$(cc) $(cflags) -o $(bin_dir)/$(basename $@) $<
	$(bin_dir)/$(basename $@)