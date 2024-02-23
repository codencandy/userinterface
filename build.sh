FRAMEWORKS='-framework AppKit'
FLAGS='-std=c++20 --debug'
TIMEFORMAT=%R

platform()
{
    clang ${FRAMEWORKS} CNC_Main.mm -o userinterface ${FLAGS}
}

main()
{
    time platform
}

main
