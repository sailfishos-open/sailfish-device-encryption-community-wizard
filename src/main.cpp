#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QGuiApplication>
#include <QQmlEngine>
#include <QQuickView>
#include <QDebug>

#include <sailfishapp.h>

#include <signal.h>

#include <devenc/devicelist.h>
#include <devenc/passwordmaker.h>

int main(int argc, char *argv[])
{
  QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

  // check if we need to start the wizard
  if (!DevEnc::DeviceList::instance()->initNeeded())
    return 0;

  QScopedPointer<QQuickView> v;
  v.reset(SailfishApp::createView());
  //QQmlContext *rootContext = v->rootContext();

  qmlRegisterType<DevEnc::Device>("org.devenc", 1, 0, "Device");
  qmlRegisterType<DevEnc::Password>("org.devenc", 1, 0, "Password");

  qmlRegisterSingletonType<DevEnc::DeviceList>("org.devenc", 1, 0, "DeviceList", [](QQmlEngine *, QJSEngine *) -> QObject * {
      return static_cast<QObject *>(DevEnc::DeviceList::instance());
  });

  qmlRegisterSingletonType<DevEnc::PasswordMaker>("org.devenc", 1, 0, "PasswordMaker", [](QQmlEngine *, QJSEngine *) -> QObject * {
      return static_cast<QObject *>(DevEnc::PasswordMaker::instance());
  });

  v->setSource(SailfishApp::pathTo("qml/main.qml"));
  v->show();

  // register signal handlers
  signal(SIGTERM, [](int /*sig*/){ qInfo("Quitting on SIGTERM"); qApp->quit(); });
  signal(SIGINT, [](int /*sig*/){ qInfo("Quitting on SIGINT"); qApp->quit(); });
  signal(SIGHUP, [](int /*sig*/){ qInfo("Quitting on SIGHUP"); qApp->quit(); });

  return app->exec();
}
