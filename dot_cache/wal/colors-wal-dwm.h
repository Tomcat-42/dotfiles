static const char norm_fg[] = "#eaeaea";
static const char norm_bg[] = "#000000";
static const char norm_border[] = "#484848";

static const char sel_fg[] = "#eaeaea";
static const char sel_bg[] = "#66b61a";
static const char sel_border[] = "#eaeaea";

static const char urg_fg[] = "#eaeaea";
static const char urg_bg[] = "#eb3d51";
static const char urg_border[] = "#eb3d51";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
