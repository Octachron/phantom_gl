rule comment=parse
| ['\n'] {lex lexbuf}
| _ { comment lexbuf}

and macro=parse
 | ['A'-'Z']+ as s {MacroWord(s)}
 | ['0x']['0'-'9']+ as s {Int(int_of_string s)}
 | ['\n'] {lex lexbuf}

and lex= parse
| [' ' 'n' '\t']+ {lex lexbuf }
| "\\\\" {comment lexbuf}
| ['#'] {macro lexbuff}
| ['*'] {Pointer}
| [';' ] {End}
| ['('] {LPar}
| [')'] {RPar}
| ['a'-'z']+ as s {Word(s)}
| eof {EOF}
