set(QT_MODULES
    Qt6Bluetooth
    Qt6BuildInternals
    Qt6BundledFreetype
    Qt6BundledLibjpeg
    Qt6BundledLibpng
    Qt6Bundled_Clip2Tri
    Qt6Concurrent
    Qt6Core
    Qt6Core5Compat
    Qt6CoreTools # only on desktops
    Qt6LinguistTools # only on desktops
    Qt6WidgetsTools # only on desktops
    Qt6GuiTools # only on desktops
    Qt6Designer
    Qt6Gui
    Qt6Help
    Qt6HostInfo
    Qt6LabsAnimation
    Qt6LabsFolderListModel
    Qt6LabsQmlModels
    Qt6LabsSettings
    Qt6LabsSharedImage
    Qt6LabsWavefrontMesh
    Qt6Linguist
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
    Qt6QmlDomPrivate
    Qt6QmlIntegration
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
    Qt6Tools
    Qt6UiPlugin
    Qt6UiTools
    Qt6Widgets
    Qt6Xml
)

set(Qt6_DIR $ENV{Qt6_DIR}/lib/cmake)

if(EXISTS ${Qt6_DIR})
    MESSAGE("Using Qt6_DIR: ${Qt6_DIR}")
else()
    MESSAGE(FATAL_ERROR "Qt6 installation not found: ${Qt6_DIR}")
endif()

foreach(MOD ${QT_MODULES})
  set(${MOD}_DIR ${Qt6_DIR}/${MOD})
  if(NOT EXISTS ${Qt6_DIR}/${MOD})
      MESSAGE(FATAL_ERROR "Qt6 ${MOD} not found: ${Qt6_DIR}/${MOD}")
  endif()
endforeach()

_find_package(${ARGS})