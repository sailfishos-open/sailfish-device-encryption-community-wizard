#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>

class System : public QObject
{
    Q_OBJECT

public:
    explicit System(QObject *parent = nullptr);

    Q_INVOKABLE void reboot();
};

#endif // SYSTEM_H
