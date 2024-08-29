+++
title = 'BigRep Modding Klipper'
date = 2024-08-29T16:16:36+02:00
draft = true
+++

Having to opportunity to fix and modernize a large format 3d-printer at my local makerspace sounds like a cool challenge! Especially when it's about a professional printer (with a profesisonal pricetag) that you usually don't have access to as a hobbyist.
The exact type of this printer model is unknown to me, but it is some early version of the `BigRep ONE`, manufactured in 2016 or so.

## Investigating BigRep ONE
While the newer BigRep machines come shipped with a Windows embedded PC (apparently for some motor driver compatibility reasons...) the printer I'm working on still had a linux-pc with LUbuntu 16.04 installed.
This Computer is connected via USB to a so called `BoogieBoard` with is BigRep's modified version of the OpenSource [SmoothieBoard](https://smoothieware.github.io/smoothieware-website-v1//smoothieboard-v1).
To be specific, the board in this printer had the version `Boogieboard 1 3`.

The root password for the Linux Computer is written in the service protocol, that's great! The frontend on this PC is just a modified OctoPrint with the capability to update the modified SmoothieWare firmware running on the Boogieboard.


## Flashing Klipper

## Mechanical Issues
