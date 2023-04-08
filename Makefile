# Makefile to compile C/C++ with MinGw
# author: KLT
# date: 2023/03/09

# Defines program target and name
APPNAME 		:= main 
TARGET			:= main.c

# Define compiler and compiler target
CC 				:= gcc
CXX				:= g++
CC_STD 			:= -std=c11
CXX_STD			:= -std=c++17

# Define a extra flags and diretives for compilation
EXTRA_FLAGS 	:= -fopenmp -lopengl32 -lglu32 -lfreeglut

# Define directories
BIN_DIR 		:= ./bin
SRC_DIR 		:= ./src
OBJ_DIR 		:= ./obj
LIB_DIR 		:= ./lib
INCLUDE_DIR 	:= ./include

# Define compiler flags
OPTIONAL_FLAGS := -Wextra -Wall
INCLUDE_FLAG 	:= -I $(INCLUDE_DIR)
CFLAGS 			:= $(CC_STD) $(OPTIONAL_FLAGS) $(EXTRA_FLAGS) $(INCLUDE_FLAG)
CXXFLAGS 		:= $(CXX_STD) $(OPTIONAL_FLAGS) $(EXTRA_FLAGS) $(INCLUDE_FLAG)

# Define RM command 
RM 				:= rm -fr

# Define all source files and header files
HEADER_FILES 	:= $(wildcard *.h)$(wildcard $(INCLUDE_DIR)/*.h)$(wildcard *.hpp) $(wildcard $(INCLUDE_DIR)/*.hpp)
SOURCE_FILES 	:= $(wildcard *.c)$(wildcard $(SRC_DIR)/*.c)$(wildcard *.cpp)$(wildcard $(SRC_DIR)/*.cpp)

# Define all header files
SRC_INC			:= $(patsubst $(SRC_DIR)/%.c,$(INCLUDE_DIR)/%.h,$(SOURCE_FILES))
FILTER_INC		:= $(filter $(SRC_INC),$(HEADER_FILES))
HXX_FILES		:= $(patsubst $(INCLUDE_DIR)/%.h,$(OBJ_DIR)/%.o,$(FILTER_INC))
OBJ_FILES		:= $(patsubst $(INCLUDE_DIR)/%.hpp,$(OBJ_DIR)/%.o,$(HXX_FILES))
C_OBJ 			:= $(filter $(OBJ_DIR)/%.o,$(HXX_FILES))
OBJ 			:= $(notdir $(OBJ_FILES))

# Define Recipes
.PHONY: all run build compile clean %.o %.exe

# Build and runs the app
all: build run

# Run the app 
run:
	@if [ -f $(APPNAME)]; then\
		$(APPNAME); \
	elif [ -f $(BIN_DIR)/$(APPNAME) ]; then \
		$(BIN_DIR)/$(APPNAME); \
	else \
		echo "Not found $(APPNAME)"; \
	fi
	
# Build the app adding statics libs using CXX compiler
build: compile
	@if [ -f $(TARGET) ]; then \
		$(CXX) $(CXXFLAGS) $(TARGET) -o $(APPNAME) $(OBJ_FILES) $(EXTRA_FLAGS); \
	else \
		mkdir -p $(BIN_DIR); \
		$(CXX) $(CXXFLAGS) $(SRC_DIR)/$(TARGET) -o $(BIN_DIR)/$(APPNAME) $(OBJ_FILES) $(EXTRA_FLAGS); \
	fi

# Build the app adding statics libs using CC compiler
cbuild: compile
	@if [ -f $(TARGET) ]; then \
		$(CC) $(CFLAGS) $(TARGET) -o $(APPNAME) $(C_OBJ) $(EXTRA_FLAGS); \
	else \
		mkdir -p $(BIN_DIR); \
		$(CC) $(CFLAGS) $(SRC_DIR)/$(TARGET) -o $(BIN_DIR)/$(APPNAME) $(C_OBJ) $(EXTRA_FLAGS); \
	fi

# Compile all source files
compile: clean $(OBJ)

# Remove all binaries
clean:
	@$(RM) $(BIN_DIR) $(OBJ_DIR) $(wildcard *.o) $(wildcard *.exe)

version:
	@echo "v2.0.0"

# Compile a static lib if exists a source code and a header file
%.o: %.c %.h
	@$(CC) $(CFLAGS) -c $< -o $@ $(EXTRA_FLAGS)

# Compile a static lib in OBJ folder if exists the source code is in source folder and header file is in include folder
%.o: $(SRC_DIR)/%.c $(INCLUDE_DIR)/%.h
	@mkdir -p $(OBJ_DIR);
	@$(CC) $(CFLAGS) -c $< -o $(OBJ_DIR)/$(notdir $@) $(EXTRA_FLAGS)

# Compile a static lib if exists a source code and a header file
%.o: %.cpp %.hpp
	@$(CXX) $(CXXFLAGS) -c $< -o $@ $(EXTRA_FLAGS)

# Compile a static lib in OBJ folder if exists the source code is in source folder and header file is in include folder
%.o: $(SRC_DIR)/%.cpp $(INCLUDE_DIR)/%.hpp
	@mkdir -p $(OBJ_DIR);
	@$(CXX) $(CXXFLAGS) -c $< -o $(OBJ_DIR)/$(notdir $@) $(EXTRA_FLAGS)

# Build and run a source file
%.exe: %.c clean compile
	@$(CC) $(CFLAGS) $< -o $(basename $@) $(C_OBJ) $(EXTRA_FLAGS)
	@$(basename $@)

# Build and run a source file if it is in source folder
%.exe: $(SRC_DIR)/%.c clean compile
	@mkdir -p $(BIN_DIR)
	@$(CC) $(CFLAGS) $< -o $(BIN_DIR)/$(basename $@) $(C_OBJ) $(EXTRA_FLAGS)
	@$(BIN_DIR)/$(basename $@)

# Build and run a source file
%.exe: %.cpp clean compile
	@$(CXX) $(CXXFLAGS) $< -o $(basename $@) $(OBJ_FILES) $(EXTRA_FLAGS)
	@$(basename $@)

# Build and run a source file if it is in source folder
%.exe: $(SRC_DIR)/%.cpp clean compile
	@mkdir -p $(BIN_DIR)
	@$(CXX) $(CXXFLAGS) $< -o $(BIN_DIR)/$(basename $@) $(OBJ_FILES) $(EXTRA_FLAGS)
	@$(BIN_DIR)/$(basename $@)