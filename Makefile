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
include_cflags 	:= -I $(include_dir)
cflags 			:= $(cc_std) $(optional_cflags) $(extra_cflags) $(include_cflags)
cxxflags 		:= $(cxx_std) $(optional_cflags) $(extra_cflags) $(include_cflags)

# Define RM command 
rm 				:= rm -fr

# Define all source files and header files

header_files 	:= $(wildcard *.h)$(wildcard $(include_dir)/*.h)$(wildcard *.hpp) $(wildcard $(include_dir)/*.hpp)
source_files 	:= $(wildcard *.c)$(wildcard $(src_dir)/*.c)$(wildcard *.cpp)$(wildcard $(src_dir)/*.cpp)

# Define all header files
hxx_files		:= $(patsubst $(include_dir)/%.h,$(obj_dir)/%.o,$(header_files))
obj_files		:= $(patsubst $(include_dir)/%.hpp,$(obj_dir)/%.o,$(hxx_files))
obj 			:= $(notdir $(obj_files))

# Define Recipes
.PHONY: all run build compile clean %.o %.exe

# Build and runs the app
all: build run

# Run the app 
run:
	@if [ -f $(appname)]; then\
		$(appname); \
	elif [ -f $(bin_dir)/$(appname) ]; then \
		$(bin_dir)/$(appname); \
	else \
		echo "Not found $(appname)"; \
	fi
	

# Build the app adding statics libs
build: compile
	@if [ -f $(target) ]; then \
		$(cxx) $(cxxflags) $(target) -o $(appname) $(obj_files); \
	else \
		$(cxx) $(cxxflags) $(src_dir)/$(target) -o $(appname) $(obj_files); \
	fi

# Compile all source files
compile: clean $(obj)

# Remove all binaries
clean:
	@$(rm) $(bin_dir) $(obj_dir) $(wildcard *.o) $(wildcard *.exe)

# Compile a static lib expecifying full path to compilation if exists a source code and a header file
%.o: %.c %.h
	@$(cc) $(cflags) -c $< -o $@

# Compile a static lib in obj folder if exists the source code is in source folder and header file is in include folder
%.o: $(src_dir)/%.c $(include_dir)/%.h
	@mkdir -p $(obj_dir);
	@$(cc) $(cflags) -c $< -o $(obj_dir)/$(notdir $@)

%.o: %.cpp %.hpp
	@$(cxx) $(cxxflags) -c $< -o $@

%.o: $(src_dir)/%.cpp $(include_dir)/%.hpp
	@mkdir -p $(obj_dir);
	@$(cxx) $(cxxflags) -c $< -o $(obj_dir)/$(notdir $@)

# Build and run a source file
%.exe: %.c clean compile
	@$(cc) $(cflags) $< -o $(basename $@) $(obj_files)
	@$(basename $@)

# Build and run a source file if it is in source folder
%.exe: $(src_dir)/%.c clean compile
	@mkdir -p $(bin_dir);
	@$(cc) $(cflags) $< -o $(bin_dir)/$(basename $@) $(obj_files)
	@$(bin_dir)/$(basename $@)

# Build and run a source file
%.exe: %.cpp clean compile
	@$(cxx) $(cxxflags) $< -o $(basename $@) $(obj_files)
	@$(basename $@)

# Build and run a source file if it is in source folder
%.exe: $(src_dir)/%.cpp clean compile
	@mkdir -p $(bin_dir);
	@$(cxx) $(cxxflags) $< -o $(bin_dir)/$(basename $@) $(obj_files)
	@$(bin_dir)/$(basename $@)