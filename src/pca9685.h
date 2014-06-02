#ifndef PCA9685_H
#define PCA9685_H
#include "driverBase.h"

class PCA9685 : public DriverBase
{
    Q_OBJECT
public:
    explicit PCA9685(unsigned char address);
    ~PCA9685();

    void init();

    void updateLeds(char data[], int offset, int len);

private:
    unsigned char driverAddress;
};

#endif // PCA9685_H
