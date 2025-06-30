/* Outline color */
#define BAR_OUTLINE #262626
/* Outline width (in pixels, set to 0 to disable outline drawing) */
#define BAR_OUTLINE_WIDTH 0
/* Amplify magnitude of the results each bar displays */
#define AMPLIFY 300
/* Whether the current settings use the alpha channel;
   enabling this is required for alpha to function
   correctly on X11 with "native" transparency. */
#define USE_ALPHA 1
/* How strong the gradient changes */
#define GRADIENT_POWER 120

// Helper function: linear interpolation between two colors
#define LERP_COLOR(c1, c2, t) (c1 * (1.0 - t) + c2 * t)

// Compute bass level (~ index 0.05 low frequencies)
#define BASS_LEVEL (smooth_audio(audio_l, audio_sz, 0.05) * AMPLIFY * 0.01)
#define BASS_SMOOTH smoothstep(0.0, 1.0, BASS_LEVEL)

// Compute treble level (~ index 0.25 high frequencies)
#define TREBLE_LEVEL (smooth_audio(audio_l, audio_sz, 0.25) * AMPLIFY * 0.01)
#define TREBLE_SMOOTH smoothstep(0.0, 1.0, TREBLE_LEVEL)

// Bass + treble-driven offset centered around zero for smooth oscillation
#define GRADIENT_OFFSET ((BASS_SMOOTH - 0.5) * 20.0 + (TREBLE_SMOOTH - 0.5) * 15.0)

// Adjusted distance with offset for color interpolation, clamped within gradient range
#define ADJUSTED_D (clamp(d + GRADIENT_OFFSET, 0.0, GRADIENT_POWER))

// Normalize adjusted distance
#define NORM_D (ADJUSTED_D / GRADIENT_POWER)

// Pulse factor (modulates brightness based on bass) — chill effect
#define PULSE (1.0 + BASS_SMOOTH * 0.1)

// Adjusted fixed band limits: bottom 50%, middle 40%, top 10%
#define LOWER_BOUND 0.5
#define UPPER_BOUND 0.9

// Define base colors with alpha (opacity about 80%)
#define COLOR_BOTTOM #FF7F00cc   // Vibrant orange (less red, more orange)
#define COLOR_MIDDLE #888888cc   // Stone grey
#define COLOR_TOP    #003366cc   // Deep natural blue

// Interpolate final color smoothly with pulse brightness
#define COLOR ( \
    (NORM_D < LOWER_BOUND) ? \
        LERP_COLOR(COLOR_BOTTOM, COLOR_MIDDLE, NORM_D / LOWER_BOUND) : \
    (NORM_D < UPPER_BOUND) ? \
        LERP_COLOR(COLOR_MIDDLE, COLOR_TOP, (NORM_D - LOWER_BOUND) / (UPPER_BOUND - LOWER_BOUND)) : \
        COLOR_TOP \
) * PULSE

/* Direction that the bars are facing, 0 for inward, 1 for outward */
#define DIRECTION 1
/* Whether to switch left/right audio buffers */
#define INVERT 0
/* Whether to flip the output vertically */
#define FLIP 0
/* Disable mirroring so spectrum runs left to right continuously */
#define MIRROR_YX 0
