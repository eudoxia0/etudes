#include <stdio.h>
#include <unistd.h>
#include <directfb.h>

static IDirectFB *dfb = NULL;
static IDirectFBSurface *primary = NULL;
static int screen_width  = 0;
static int screen_height = 0;

#define DFBCHECK(x...)                                         \
  {                                                            \
    DFBResult err = x;                                         \
                                                               \
    if (err != DFB_OK)                                         \
      {                                                        \
        fprintf( stderr, "%s <%d>:\n\t", __FILE__, __LINE__ ); \
        DirectFBErrorFatal( #x, err );                         \
      }                                                        \
  }

int main (int argc, char **argv)
{
  DFBSurfaceDescription dsc;

  DFBCHECK (DirectFBInit (&argc, &argv));
  DFBCHECK (DirectFBCreate (&dfb));
  DFBCHECK (dfb->SetCooperativeLevel (dfb, DFSCL_FULLSCREEN));

  dsc.flags = DSDESC_CAPS;
  dsc.caps  = DSCAPS_PRIMARY | DSCAPS_FLIPPING;

  DFBCHECK (dfb->CreateSurface( dfb, &dsc, &primary ));
  DFBCHECK (primary->GetSize (primary, &screen_width, &screen_height));
  DFBCHECK (primary->FillRectangle (primary, 0, 0, screen_width, screen_height));

  DFBCHECK (primary->SetColor (primary, 0x80, 0x80, 0xff, 0xff));
  DFBCHECK (primary->DrawLine (primary,
			                      0, screen_height / 2,
			       screen_width - 1, screen_height / 2));
  DFBCHECK (primary->Flip (primary, NULL, 0));

  sleep (5);

  primary->Release( primary );
  dfb->Release( dfb );

  return 23;
}
