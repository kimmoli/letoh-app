#include "pca9685.h"
#include <QThread>

PCA9685::PCA9685(unsigned char address)
{
    driverAddress = address;
    init();
}

PCA9685::~PCA9685()
{

}

/*
 * Routine to initialse PCA9685 chips
 *
 */
void PCA9685::init()
{
    char buf[2] = { 0 };

    buf[0] = 0;
    buf[1] = 0x20;

    writeBytes(driverAddress, buf, 2);

    QThread::msleep(1);

    buf[0] = 0;
    buf[1] = 0xa0;

    writeBytes(driverAddress, buf, 2);
}

void PCA9685::updateLeds(char data[], int offset, int len)
{
    char buf[255] = {0};

    buf[0] = 0x06; /* Address of LED0_ON_L register */

    for (int i=0; i< len; i++)
        buf[1+i] = data[offset+i];

    writeBytes(driverAddress, buf, len+1);
}
