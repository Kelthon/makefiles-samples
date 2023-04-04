# Makefile to compile C/C++ source files on Linux v1.0

# author: KLT
# date: 2023/03/09

cc 				= gcc
appname 		= main
target 			= main.c
extra_cflags	= -fopenmp -lpthread
cc_std 			= -std=c11
cflags 			= -Wextra -Wall -I

bin_dir 		= ./bin
src_dir 		= ./src
obj_dir 		= ./obj
include_dir 	= ./include

source_files 	:= $(wildcard $(src_dir)/*.c)
target_path		:= $(addprefix $(src_dir)/,$(target))
filtered_files 	:= $(filter-out $(target_path),$(source_files))
obj_paths 		:= $(patsubst $(src_dir)/%.c,$(obj_dir)/%.o,$(filtered_files))
obj				:= $(notdir $(obj_paths))

.PHONY: all
all: compile run

run: $(bin_dir)/$(appname)
	$(bin_dir)/$(appname)

compile: clean build
	@echo KLT's Makefile for C/C++ Source Files v1.0

build: $(obj)
	$(cc) $(cflags) $(include_dir) $(src_dir)/$(target) -o $(bin_dir)/$(appname) $(obj_paths)

.PHONY: clean
clean:
	@rm -rf $(wildcard $(bin_dir)/*) $(wildcard $(obj_dir)/*)

%.o: $(src_dir)/%.c $(include_dir)/%.h
	$(cc) $(cflags) $(include_dir) -c ./$< -o $(obj_dir)/$@

cxproject:
	@mkdir -o $(bin_dir) $(src_dir) $(obj_dir) $(include_dir)
	@> $(addprefix $(src_dir),$(target))