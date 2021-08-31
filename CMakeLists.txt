cmake_minimum_required(VERSION 3.5)

project(sailfish-device-encryption-community-wizard
    LANGUAGES CXX
    VERSION 0.1
    DESCRIPTION "Startup Wizard for Device Encryption"
)

find_package (Qt5 COMPONENTS Core Qml Gui Quick REQUIRED)

include(FindPkgConfig)
pkg_search_module(SAILFISH sailfishapp REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)


# sources

## QML sources: installed in subdir
file(GLOB QML_SRC qml/*.qml)

## C++ sources
file(GLOB CXX_SRC src/*.cpp)
file(GLOB CXX_HEADERS src/*.h)

## Translations
FILE(GLOB TsFiles "translations/*.ts")

add_custom_target(Sources SOURCES
    ${QML_SRC}
    ${CXX_SRC} ${CXX_HEADERS}
    ${TsFiles}
    rpm/sailfish-device-encryption-community-wizard.spec
    )

# compilation
add_compile_options(
)

add_executable(sailfish-device-encryption-community-wizard ${CXX_SRC} ${CXX_HEADERS})

target_compile_definitions(sailfish-device-encryption-community-wizard PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
target_include_directories(sailfish-device-encryption-community-wizard PRIVATE
    $<BUILD_INTERFACE:
    ${SAILFISH_INCLUDE_DIRS}
>)
target_link_libraries(sailfish-device-encryption-community-wizard
    Qt5::Quick
    sfosdevenc
    ${SAILFISH_LDFLAGS}
)

# installs
install(TARGETS sailfish-device-encryption-community-wizard
    RUNTIME DESTINATION bin
)
install(DIRECTORY qml
    DESTINATION share/sailfish-device-encryption-community-wizard
)
install(DIRECTORY translations
    DESTINATION share/sailfish-device-encryption-community-wizard
    FILES_MATCHING PATTERN "*.qm"
)
