local present, knap = pcall(require, "knap")

if not present then return end

local config = {
    htmloutputext = "html",
    htmltohtml = "A=%outputfile% ; B=\"${A%.html}-preview.html\" ; sed 's/<\\/head>/<meta http-equiv=\"refresh\" content=\"1\" ><\\/head>/' \"$A\" > \"$B\"",
    htmltohtmlviewerlaunch = "A=%outputfile% ; B=\"${A%.html}-preview.html\" ; firefox \"$B\"",
    htmltohtmlviewerrefresh = "none",
    mdtohtml = "A=%outputfile% ; B=\"${A%.html}-preview.html\" ; pandoc --standalone %docroot% -o \"$A\" && sed 's/<\\/head>/<meta http-equiv=\"refresh\" content=\"1\" ><\\/head>/' \"$A\" > \"$B\" ",
    mdtohtmlviewerlaunch = "A=%outputfile% ; firefox \"${A%.html}-preview.html\"",
    mdtohtmlviewerrefresh = "none",
    mdoutputext = "pdf",
    mdtopdf = "pandoc %docroot% -o %outputfile%",
    mdtopdfviewerlaunch = "zathura %outputfile%",
    mdtopdfviewerrefresh = "none",
    markdownoutputext = "pdf",
    markdowntohtml = "pandoc --standalone %docroot% -o %outputfile%",
    markdowntohtmlviewerlaunch = "firefox %outputfile%",
    markdowntohtmlviewerrefresh = "none",
    markdowntopdf = "pandoc %docroot% -o %outputfile%",
    markdowntopdfviewerlaunch = "pdf %outputfile%",
    markdowntopdfviewerrefresh = "none",
    texoutputext = "pdf",
    textopdf = "pdflatex -interaction=batchmode -halt-on-error -synctex=1 %docroot%",
    textopdfviewerlaunch = "zathura --synctex-editor-command 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%",
    textopdfviewerrefresh = "none",
    textopdfforwardjump = "zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%",
    textopdfshorterror = "A=%outputfile% ; LOGFILE=\"${A%.pdf}.log\" ; rubber-info \"$LOGFILE\" 2>&1 | head -n 1",
    delay = 250
}

vim.g.knap_settings = config
