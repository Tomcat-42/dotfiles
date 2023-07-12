""
"" midir.vim
""
"" Made by Pablo Alessandro Santos Hugen
"" Email: pablohuggem@gmail.com
""

" Vim syntax file based on the C syntax file by Bram Moolenaar <Bram@vim.org>

" INSTALL instructions:
" install midir-ftdetect.vim
" $ mkdir -p ~/.vim/syntax
" $ cp midir.vim ~/.vim/syntax

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" A bunch of useful Midir keywords
syn keyword	midirStatement		break let in end of
syn keyword	midirConditional	if then else
syn keyword	midirRepeat		while for to do

syn keyword	midirTodo		contained TODO FIXME XXX NOTE[S]

" midirCommentGroup allows adding matches for special things in comments
syn cluster	midirCommentGroup	contains=midirTodo

" String constants (Note: there is no character constants in midir)
" Highlight special characters (those which have a backslash) differently
syn match	midirSpecial		display contained "\\\(x\x\{2}\|\o\{3}\|a\|b\|f\|n\|r\|t\|v\|\\\|\"\)"
" Highlight invalid escapes
syn match	midirSpecialError	display contained "\\[^0-9abfnrtvx\\\"]"
syn match	midirSpecialError	display contained "\\x[^0-9a-fA-F]"
syn match	midirSpecialError	display contained "\\x\x[^0-9a-fA-F]"
syn region	midirString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=midirSpecial,midirSpecialError,Spell

syn match	midirSpaceError		display excludenl "\s\+$"
syn match	midirSpaceError		display " \+\t"me=e-1

"catch errors caused by wrong parenthesis and brackets
syn cluster	midirParenGroup		contains=midirParenError,midirSpecial,midirSpecialError,midirCommentGroup,midirNumber,midirNumbersCom
syn region	midirParen		transparent start='(' end=')' contains=ALLBUT,@midirParenGroup,midirErrInBracket,Spell
syn match	midirParenError		display "[\])]"
syn match	midirErrInParen		display contained "[\]]"
syn region	midirBracket		transparent start='\[' end=']' contains=ALLBUT,@midirParenGroup,midirErrInParen,Spell
syn match	midirErrInBracket	display contained "[);{}]"

" integer number (Note: octal or hexadecimal literals don't exist in midir.)
"                (Numbers starting with a 0 are not considered in a special way)
syn case ignore
syn match	midirNumbers		display transparent "\<\d\|\.\d" contains=midirNumber
" Same, but without octal error (for comments)
syn match	midirNumbersCom		display contained transparent "\<\d\|\.\d" contains=midirNumber
syn match	midirNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
syn case match

syn region	midirComment		matchgroup=midirCommentStart start="/\*" end="\*/" contains=@midirCommentGroup,midirComment,@Spell

syn keyword	midirType		int string

syn keyword	midirStructure		type list
syn keyword	midirStorageClass	var
syn keyword	midirDecl		fn primitive
syn keyword	midirImport		use
syn keyword	midirNil		nil
syn keyword	midirBuiltin		chr concat exit flush getchar not ord print print_err print_int size strcmp streq substring

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_midir_syn_inits")
  if version < 508
    let did_midir_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink midirCommentL		midirComment
  HiLink midirCommentStart	midirComment
  HiLink midirConditional	Conditional
  HiLink midirRepeat		Repeat
  HiLink midirNumber		Number
  HiLink midirParenError	midirError
  HiLink midirErrInParen	midirError
  HiLink midirErrInBracket	midirError
  HiLink midirSpaceError	midirError
  HiLink midirSpecialError	midirError
  HiLink midirStructure		Structure
  HiLink midirStorageClass	StorageClass
  HiLink midirDefine		Macro
  HiLink midirError		Error
  HiLink midirStatement		Statement
  HiLink midirType		Type
  HiLink midirConstant		Constant
  HiLink midirString		String
  HiLink midirComment		Comment
  HiLink midirSpecial		SpecialChar
  HiLink midirTodo		Todo
  HiLink midirDecl		Type
  HiLink midirImport            Include
  HiLink midirNil               Constant
  HiLink midirBuiltin		Define

  delcommand HiLink
endif

let b:current_syntax = "midir"

" vim: ts=8
