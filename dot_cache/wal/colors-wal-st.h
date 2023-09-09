const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#000000", /* black   */
  [1] = "#eb3d51", /* red     */
  [2] = "#66b61a", /* green   */
  [3] = "#d98e1d", /* yellow  */
  [4] = "#23ffa8", /* blue    */
  [5] = "#ff00da", /* magenta */
  [6] = "#68a783", /* cyan    */
  [7] = "#eaeaea", /* white   */

  /* 8 bright colors */
  [8]  = "#484848",  /* black   */
  [9]  = "#eb3d51",  /* red     */
  [10] = "#66b61a", /* green   */
  [11] = "#d98e1d", /* yellow  */
  [12] = "#23ffa8", /* blue    */
  [13] = "#ff00da", /* magenta */
  [14] = "#68a783", /* cyan    */
  [15] = "#eaeaea", /* white   */

  /* special colors */
  [256] = "#000000", /* background */
  [257] = "#ffffff", /* foreground */
  [258] = "#be6262",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
