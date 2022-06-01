const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#1e1f26", /* black   */
  [1] = "#FF5555", /* red     */
  [2] = "#50FA7B", /* green   */
  [3] = "#F1FA8C", /* yellow  */
  [4] = "#BD93F9", /* blue    */
  [5] = "#FF79C6", /* magenta */
  [6] = "#8BE9FD", /* cyan    */
  [7] = "#F8F8F2", /* white   */

  /* 8 bright colors */
  [8]  = "#6272A4",  /* black   */
  [9]  = "#FF6E6E",  /* red     */
  [10] = "#69FF94", /* green   */
  [11] = "#FFFFA5", /* yellow  */
  [12] = "#D6ACFF", /* blue    */
  [13] = "#FF92DF", /* magenta */
  [14] = "#A4FFFF", /* cyan    */
  [15] = "#FFFFFF", /* white   */

  /* special colors */
  [256] = "#1e1f26", /* background */
  [257] = "#FFFFFF", /* foreground */
  [258] = "#FFFFFF",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
