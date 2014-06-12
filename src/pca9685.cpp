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
    char buf[3] = { 0 };

    buf[0] = 0;     /* Mode register 1, MODE1 */
    buf[1] = 0x20;  /* Register autoincrement enable, normal mode */

    writeBytes(driverAddress, buf, 2);

    /* The SLEEP bit mustbe logic 0 for at least 500μs,
     * before a logic 1 is written into the RESTART bit.
     */
    QThread::msleep(1);

    buf[0] = 0;     /* Mode register 1, MODE1 */
    buf[1] = 0xa0;  /* Restart */
                    /* Mode register 2, MODE2 */
    buf[2] = 0x10;  /* Invert, opendrain */

    writeBytes(driverAddress, buf, 3);
}

void PCA9685::updateLeds(char data[], int offset, int len)
{
    char buf[255] = {0};

    buf[0] = 0x06; /* Address of LED0_ON_L register */

    for (int i=0; i< len; i++)
        buf[1+i] = data[offset+i];

    writeBytes(driverAddress, buf, len+1);
}
