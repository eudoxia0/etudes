#include "colors.inc"
#include "textures.inc"
#include "shapes.inc"
#include "glass.inc"
#include "metals.inc"
#include "woods.inc"
#include "stones.inc"

#declare T_Sun =
  texture {
    pigment {
      bozo frequency 4
      turbulence 0.7
      omega 0.7
      color_map
      {
        [0.00 color Orange]
        [0.33 color Yellow]
        [0.55 color Red]
      }
      rotate 50*z
    }
    finish { ambient 0.7 }
  }

sphere {
  <0, 0, 0>, 10
  hollow
  interior {
    media {
      emission <1,0.5,0>
      intervals 3
      samples 1,1
    }
  }
  texture { T_Sun scale 4 }
}

torus {
  20, 0.05
  interior {
    media {
      emission 10
      intervals 3
      samples 1,1
    }
  }
  pigment { White }
}

#declare cdist = 28;
#declare cup = 5;

camera {
  location <cdist, cup, cdist>
  look_at  <0, 0, 0>
}
