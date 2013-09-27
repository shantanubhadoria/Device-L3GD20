package Device::Gyroscope::L3GD20;

# PODNAME: Device::Gyroscope::L3GD20
# ABSTRACT: I2C interface to Gyroscope on the L3GD20 using Device::SMBus
# COPYRIGHT
# VERSION

# Dependencies
use 5.010;
use Moose;
use POSIX;

use Time::HiRes qw(time);

extends 'Device::SMBus';

=attr I2CDeviceAddress

Containd the I2CDevice Address for the bus on which your gyroscope is connected. It would look like 0x6b. Default is 0x6b.

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

=attr XZero
    
This is the raw value for the X axis when the gyro is stationary. This is a part of gyro calibration to get more accurate values for rotation.

=cut

has XZero => (
    is      => 'rw',
    default => 0,
);

=attr YZero
    
This is the raw value for the Y axis when the gyro is stationary. This is a part of gyro calibration to get more accurate values for rotation.

=cut

has YZero => (
    is      => 'rw',
    default => 0,
);

=attr ZZero
    
This is the raw value for the Z axis when the gyro is stationary. This is a part of gyro calibration to get more accurate values for rotation.

=cut

has ZZero => (
    is      => 'rw',
    default => 0,
);

=attr lastReadingTime

Time when the last reading was taken

=cut

has lastReadingTime => (
    is      => 'rw',
    default => 0,
);

=attr timeDrift

time taken between last reading and current reading. 
Make sure to take atleast two readings before you use this value for any calculations in your program otherwise you will get a bad value in this the first time you read the gyroscope.

=cut

has timeDrift => (
    is      => 'rw',
    default => 0,
);

# Registers for the Gyroscope 
use constant {
    CTRL_REG1 => 0x20,
    CTRL_REG4 => 0x23,
};

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

Return raw readings from accelerometer registers. Note that if XZero,YZero or ZZero are set, this function returns the values adjusted from the values at default non rotating state of the gyroscope. Its recommended that you set these values to achieve accurate results from the gyroscope.

=cut

sub getRawReading {
    my ($self) = @_;

    my $currentTime = time;
    $self->timeDrift( $currentTime - $self->lastReadingTime ) if $self->lastReadingTime;
    $self->lastReadingTime( $currentTime );

    return {
        x => ( $self->_typecast_int_to_int16( $self->readNBytes(OUT_X_L,2) ) ) - $self->XZero,
        y => ( $self->_typecast_int_to_int16( $self->readNBytes(OUT_Y_L,2) ) ) - $self->YZero,
        z => ( $self->_typecast_int_to_int16( $self->readNBytes(OUT_Z_L,2) ) ) - $self->ZZero,
    };
}

=method getReading

Return gyroscope readings in degrees per second

=cut

sub getReading {
    my ($self) = @_;

    my $gain = $self->gyroscopeGain;
    my $gyro = $self->getRawReading;
    return {
        x => ( $gyro->{x} * $gain ),
        y => ( $gyro->{y} * $gain ),
        z => ( $gyro->{z} * $gain ),
    };
}

sub _typecast_int_to_int16 {
    return  unpack 's' => pack 'S' => $_[1];
}

sub calibrate {
    my ($self) =@_;

}

1;
