package Device::L3GD20;

# PODNAME: Device::L3GD20 
# ABSTRACT: I2C interface to L3GD20 3 axis GyroScope using Device::SMBus
# COPYRIGHT
# VERSION

use 5.010;
use Moose;
use POSIX

# Dependencies
use Device::L3GD20::Gyroscope;

has 'I2CBusDevicePath' => (
    is => 'ro',
);

has Gyroscope => (
    is => 'ro',
    isa => 'Device::L3GD20::Gyroscope',
    lazy_build => 1,
);

sub _build_Gyroscope {
    my ($self) = @_;
    my $obj = Device::L3GD20::Gyroscope->new(
        I2CBusDevicePath => $self->I2CBusDevicePath;
    );
    return $obj;
}

1;
