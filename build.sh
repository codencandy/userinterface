#! bin/bash

FRAMEWORKS='-framework AppKit -framework Metal -framework MetalKit -framework CoreVideo -framework GameController'
FLAGS='-std=c++20 --debug -Ilibs/imgui -Ilibs/imgui/backends'
TIMEFORMAT=%R
IGNORE='-Wno-nullability-completeness -Wno-unused-command-line-argument'
BUILD_TYPE=$1

all()
{
    rm -rf CNC_ImGui.o
    clang++ ${FRAMEWORKS} -c CNC_ImGui.mm ${FLAGS} ${IGNORE}
    platform
}

platform()
{
    clang++ ${FRAMEWORKS} CNC_Main.mm -o userinterface CNC_ImGui.o ${FLAGS} ${IGNORE}
}

main()
{
    if [ "$BUILD_TYPE" = "ALL" ]
    then
        time all
    else
        time platform
    fi
    
    CODE_SIZE=$(cloc --exclude-list-file=.clocignore . | grep -o -E '([0-9]+)' | tail -1)
    echo "-> LINES OF CODE: " $CODE_SIZE
}

main
