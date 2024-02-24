FRAMEWORKS='-framework AppKit -framework Metal -framework MetalKit -framework CoreVideo'
FLAGS='-std=c++20 --debug'
TIMEFORMAT=%R
IGNORE='-Wno-nullability-completeness'

platform()
{
    clang ${FRAMEWORKS} CNC_Main.mm -o userinterface ${FLAGS} ${IGNORE}
}

main()
{
    time platform
}

main
