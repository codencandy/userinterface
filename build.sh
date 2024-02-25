#! bin/bash

FRAMEWORKS='-framework AppKit -framework Metal -framework MetalKit -framework CoreVideo -framework GameController'
FLAGS='-std=c++20 --debug -Ilibs/imgui -Ilibs/imgui/backends'
TIMEFORMAT=%R
IGNORE='-Wno-nullability-completeness'

platform()
{
    clang++ ${FRAMEWORKS} CNC_Main.mm -o userinterface ${FLAGS} ${IGNORE}
}

main()
{
    time platform
    CODE_SIZE=$(cloc --exclude-dir=libs . | grep -o -E '([0-9]+)' | tail -1)
    echo "-> LINES OF CODE: " $CODE_SIZE
}

main
