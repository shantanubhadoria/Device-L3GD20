use strict;
use warnings;
package Device::L3GD20;

# PODNAME: Device::L3GD20 
# ABSTRACT: I2C interface to L3GD20 3 axis GyroScope using Device::SMBus
# COPYRIGHT
# VERSION

# Dependencies
use 5.010;
use Moose;
use POSIX;

use Device::Gyroscope::L3GD20;

=attr I2CBusDevicePath

this is the device file path for your I2CBus that the L3GD20 is connected on e.g. /dev/i2c-1
This must be provided during object creation.

=cut

has 'I2CBusDevicePath' => (
    is => 'ro',
);

=attr Gyroscope

    $self->Gyroscope->enable();
    $self->Gyroscope->getReading();

This is a object of L<Device::Gyroscope::L3GD20>

=cut

has Gyroscope => (
    is => 'ro',
    isa => 'Device::Gyroscope::L3GD20',
    lazy_build => 1,
);

sub _build_Gyroscope {
    my ($self) = @_;
    my $obj = Device::Gyroscope::L3GD20->new(
        I2CBusDevicePath => $self->I2CBusDevicePath,
    );
    return $obj;
}

1;
