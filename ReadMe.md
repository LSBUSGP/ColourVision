# Colour vision

This project provides the colour vision deficiency filters from [libDaltonLens](https://github.com/DaltonLens/libDaltonLens) as a Unity camera post render effect.

Unity developers can add this filter to their games to check that their use of colour can be distinguished by players with different levels of colour vision deficiency.

Copy the `CameraFX` folder into your Unity project's `Assets` folder. Then add the `CameraFX` script to your camera and set the `Material` to `CVDSimulator`. To see the effect in your game, changed the `Colour vision deficiency` property of the `CVDSimulator` material to:

- Protan
- Deutan
- Tritan

You can adjust the amount of the filter to apply by changing the `Strength` property of the `CVDSimulator` material.

The `Tests` folder contains a scene containing colour grids from the [libDaltonLens](https://github.com/DaltonLens/libDaltonLens) project to check that the filter is working correctly.

## Test Grid

With `Protan` selected as the `Colour vision deficiency` property of the `CVDSimulator` material, and `Strength` set to `1`, the `Test Grid` should match the `Model Protan Simulation`. Also, if you slide the `Strength` slider, the `Model Protan Simulation` image should not change.

The same should apply to the `Deutan` and `Tritan` models.

## Ishihara

This scene displays the 24 plate Ishihara test. The scans are from the PDF scan provided by https://www.challengetb.org/.
