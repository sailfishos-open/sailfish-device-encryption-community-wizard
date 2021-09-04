#include "system.h"

#include <QProcess>

System::System(QObject *parent) : QObject(parent)
{

}

void System::reboot()
{
  QProcess::execute("reboot");
}
