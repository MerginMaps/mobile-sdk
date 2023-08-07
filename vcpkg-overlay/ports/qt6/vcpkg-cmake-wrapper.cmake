set(QT_MODULES
    Qt6
    Qt6Designer
    Qt6BundledFreetype
    Qt6BuildInternals
    Qt6Bundled_Clip2Tri
    Qt6BundledPcre2
    Qt6HostInfo
    Qt6Linguist
    Qt6QmlDomPrivate
    Qt6QmlIntegration
    Qt6Tools
    Qt6UiPlugin
    Qt6Bluetooth
    Qt6BundledLibjpeg
    Qt6BundledLibpng
    Qt6Concurrent
    Qt6EntryPointPrivate
    Qt6Core
    Qt6Core5Compat
    Qt6Gui
    Qt6Help
    Qt6LabsAnimation
    Qt6LabsFolderListModel
    Qt6LabsQmlModels
    Qt6LabsSettings
    Qt6LabsSharedImage
    Qt6LabsWavefrontMesh
    Qt6Multimedia
    Qt6MultimediaWidgets
    Qt6Network
    Qt6Nfc
    Qt6OpenGL
    Qt6OpenGLWidgets
    Qt6PngPrivate
    Qt6Positioning
    Qt6PositioningQuick
    Qt6PrintSupport
    Qt6Qml
    Qt6QmlCore
    Qt6QmlLocalStorage
    Qt6QmlModels
    Qt6QmlWorkerScript
    Qt6QmlXmlListModel
    Qt6Quick
    Qt6QuickControls2
    Qt6QuickDialogs2
    Qt6QuickDialogs2Utils
    Qt6QuickLayouts
    Qt6QuickTemplates2
    Qt6QuickTest
    Qt6QuickWidgets
    Qt6Sensors
    Qt6SensorsQuick
    Qt6Sql
    Qt6Svg
    Qt6SvgWidgets
    Qt6Test
    Qt6UiTools
    Qt6Widgets
    Qt6Xml
)

set(Qt6_ROOT_DIR $ENV{Qt6_DIR}/lib/cmake)

if(EXISTS ${Qt6_ROOT_DIR})
    MESSAGE(STATUS "Using Qt6 CMAKE dir: ${Qt6_ROOT_DIR}")
else()
    MESSAGE(FATAL_ERROR "Qt6 installation not found: ${Qt6_ROOT_DIR}; Do you have Qt6_DIR environment variable set?")
endif()

foreach(MOD ${QT_MODULES})
  if(EXISTS ${Qt6_ROOT_DIR}/${MOD})
      set(${MOD}_DIR ${Qt6_ROOT_DIR}/${MOD})
      MESSAGE(STATUS "Qt6 ${MOD} found: ${Qt6_ROOT_DIR}/${MOD}")
  else()
      # Not all modules are on all platforms
      MESSAGE(STATUS "Skipped -- Qt6 ${MOD}: ${Qt6_ROOT_DIR}/${MOD}")
  endif()
endforeach()

### HOST
# These modules are not in iOS/Android Qt, but they are needed for Qt
set(QT_HOST_MODULES
    Qt6CoreTools 
    Qt6LinguistTools
    Qt6WidgetsTools
    Qt6GuiTools
)

set(Qt6_ROOT_HOST_DIR $ENV{Qt6_HOST_DIR}/lib/cmake)
if(EXISTS ${Qt6_ROOT_HOST_DIR})
  MESSAGE(STATUS "Using Qt6 host CMAKE dir from env. variable Qt6_HOST_DIR ${Qt6_ROOT_HOST_DIR}")
else()
  MESSAGE(STATUS "Using Qt6 host CMAKE dir from env. variable Qt6_DIR; for iOS or Android you need to set Qt6_HOST_DIR environment variable instead.")
  set(Qt6_ROOT_HOST_DIR ${Qt6_ROOT_DIR})
endif()

foreach(MOD ${QT_HOST_MODULES})
  if(EXISTS ${Qt6_ROOT_HOST_DIR}/${MOD})
      set(${MOD}_DIR ${Qt6_ROOT_HOST_DIR}/${MOD})
      MESSAGE(STATUS "Qt6 HOST ${MOD} found: ${Qt6_ROOT_DIR}/${MOD}")
  else()
      MESSAGE(STATUS "Skipped -- Qt6 HOST ${MOD} not found: ${Qt6_ROOT_HOST_DIR}/${MOD}")
  endif()
endforeach()

_find_package(${ARGS})