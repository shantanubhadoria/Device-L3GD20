use strict;
use warnings;
package Device::Gyroscope::L3GD20;

# PODNAME: Device::Gyroscope::L3GD20
# ABSTRACT: I2C interface to Gyroscope on the L3GD20 using Device::SMBus
# COPYRIGHT
# VERSION

# Dependencies
use 5.010;
use POSIX;

use Math::Trig  qw(deg2rad);

use Moose;
extends 'Device::SMBus';

=attr I2CDeviceAddress

Contains the I2CDevice Address for the bus on which your gyroscope is connected. It would look like 0x6b. Default is 0x6b.

=cut

has '+I2CDeviceAddress' => (
    is      => 'ro',
    default => 0x6b,
);

=attr gyroscopeGain

Unless you are modifying gyroscope setup you must not change this. This contains the Gyroscope gain value which helps in converting the raw measurements from gyroscope register in to degrees per second.

=cut

has gyroscopeGain => (
    is      => 'rw',
    default => 0.07,
);

=attr xZero
    
This is the raw value for the X axis when the gyro is stationary. This is a part of gyro calibration to get more accurate values for rotation.

=cut

has xZero => (
    is      => 'rw',
    default => 0,
);

=attr yZero
    
This is the raw value for the Y axis when the gyro is stationary. This is a part of gyro calibration to get more accurate values for rotation.

=cut

has yZero => (
    is      => 'rw',
    default => 0,
);

=attr zZero
    
This is the raw value for the Z axis when the gyro is stationary. This is a part of gyro calibration to get more accurate values for rotation.

=cut

has zZero => (
    is      => 'rw',
    default => 0,
);

=register CTRL_REG1

=register CTRL_REG4

=cut

# Registers for the Gyroscope 
use constant {
    CTRL_REG1 => 0x20,
    CTRL_REG4 => 0x23,
};


=register OUT_X_H

=register OUT_X_L

=register OUT_Y_H

=register OUT_Y_L

=register OUT_Z_H

=register OUT_Z_L

=cut

# X, Y and Z Axis Gyroscope Data value in 2's complement
use constant {
    OUT_X_H => 0x29,
    OUT_X_L => 0x28,

    OUT_Y_H => 0x2b,
    OUT_Y_L => 0x2a,

    OUT_Z_H => 0x2d,
    OUT_Z_L => 0x2c,
};

#use integer; # Use arithmetic right shift instead of unsigned binary right shift with >> 4

=method enable 

    $self->enable()

Initializes the device, Call this before you start using the device. This function sets up the appropriate default registers.
The Device will not work properly unless you call this function

=cut

sub enable {
    my ($self) = @_;
    $self->writeByteData(CTRL_REG1,0b00001111);
    $self->writeByteData(CTRL_REG4,0b00110000);
}

=method getRawReading

    $self->getRawReading()

Return raw readings from registers. Note that if xZero,yZero or zZero are set, this function returns the values adjusted from the values at default non rotating state of the gyroscope. Its recommended that you set these values to achieve accurate results from the gyroscope.

=cut

sub getRawReading {
    my ($self) = @_;

    return {
        x => ( $self->_typecast_int_to_int16( $self->readNBytes(OUT_X_L,2) ) ) - $self->xZero,
        y => ( $self->_typecast_int_to_int16( $self->readNBytes(OUT_Y_L,2) ) ) - $self->yZero,
        z => ( $self->_typecast_int_to_int16( $self->readNBytes(OUT_Z_L,2) ) ) - $self->zZero,
    };
}

=method getReadingDegreesPerSecond

Return gyroscope readings in degrees per second

=cut

sub getReadingDegreesPerSecond {
    my ($self) = @_;

    my $gain = $self->gyroscopeGain;
    my $gyro = $self->getRawReading;
    return {
        x => ( $gyro->{x} * $gain ),
        y => ( $gyro->{y} * $gain ),
        z => ( $gyro->{z} * $gain ),
    };
}

=method getReadingRadiansPerSecond

Return gyroscope readings in radians per second

=cut

sub getReadingRadiansPerSecond {
    my ($self) = @_;

    my $gain = $self->gyroscopeGain;
    my $gyro = $self->getRawReading;
    return {
        x => deg2rad( $gyro->{x} * $gain ),
        y => deg2rad( $gyro->{y} * $gain ),
        z => deg2rad( $gyro->{z} * $gain ),
    };
}

sub _typecast_int_to_int16 {
    return  unpack 's' => pack 'S' => $_[1];
}

=method calibrate

Placeholder for documentation on calibration

=cut

sub calibrate {
    my ($self) =@_;

}

1;
