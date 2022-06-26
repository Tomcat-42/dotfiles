const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#000000", /* black   */
  [1] = "#ff004d", /* red     */
  [2] = "#00e756", /* green   */
  [3] = "#fff024", /* yellow  */
  [4] = "#83769c", /* blue    */
  [5] = "#ff77a8", /* magenta */
  [6] = "#29adff", /* cyan    */
  [7] = "#ffffff", /* white   */

  /* 8 bright colors */
  [8]  = "#008751",  /* black   */
  [9]  = "#ff004d",  /* red     */
  [10] = "#00e756", /* green   */
  [11] = "#fff024", /* yellow  */
  [12] = "#83769c", /* blue    */
  [13] = "#ff77a8", /* magenta */
  [14] = "#29adff", /* cyan    */
  [15] = "#fff1e8", /* white   */

  /* special colors */
  [256] = "#000000", /* background */
  [257] = "#ffffff", /* foreground */
  [258] = "#ffffff",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
