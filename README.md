# NAME

Device::L3GD20 - I2C interface to L3GD20 3 axis GyroScope using Device::SMBus

<div>
    <p>
    <img src="https://img.shields.io/badge/perl-5.10+-brightgreen.svg" alt="Requires Perl 5.10+" />
    <a href="https://travis-ci.org/shantanubhadoria/perl-Device-L3GD20"><img src="https://api.travis-ci.org/shantanubhadoria/perl-Device-L3GD20.svg?branch=build/master" alt="Travis status" /></a>
    <a href="http://matrix.cpantesters.org/?dist=Device-L3GD20%200.010"><img src="https://badgedepot.code301.com/badge/cpantesters/Device-L3GD20/0.010" alt="CPAN Testers result" /></a>
    <a href="http://cpants.cpanauthors.org/dist/Device-L3GD20-0.010"><img src="https://badgedepot.code301.com/badge/kwalitee/Device-L3GD20/0.010" alt="Distribution kwalitee" /></a>
    <a href="https://gratipay.com/shantanubhadoria"><img src="https://img.shields.io/gratipay/shantanubhadoria.svg" alt="Gratipay" /></a>
    </p>
</div>

# VERSION

version 0.010

# ATTRIBUTES

## I2CBusDevicePath

this is the device file path for your I2CBus that the L3GD20 is connected on e.g. /dev/i2c-1
This must be provided during object creation.

## Gyroscope

    $self->Gyroscope->enable();
    $self->Gyroscope->getReading();

This is a object of [Device::Gyroscope::L3GD20](https://metacpan.org/pod/Device::Gyroscope::L3GD20)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through github at 
[https://github.com/shantanubhadoria/perl-device-l3gd20/issues](https://github.com/shantanubhadoria/perl-device-l3gd20/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/shantanubhadoria/perl-device-l3gd20](https://github.com/shantanubhadoria/perl-device-l3gd20)

    git clone git://github.com/shantanubhadoria/perl-device-l3gd20.git

# AUTHOR

Shantanu Bhadoria &lt;shantanu at cpan dott org>

# CONTRIBUTOR

Shantanu <shantanu@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Shantanu Bhadoria.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
