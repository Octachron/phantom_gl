{
  open Parser

  exception Error of string
}


rule token= parse
| [' ' '\t'] {token lexbuf}
| '\\'(['A'-'z']+ as s) { MACRO s}
| '\n' {EOL}
| '{' {LBRACE}
| '}' {RBRACE}
| '$' {MATH}
| '[' {LCROC}
| ']' {RCROC}
| '%' {COMMENT}
| [^ ' ' '\t' '\n' '{' '}' '$' '[' ']' '%' '\\' eol]+ as s {Word s}
| eof {EOF}
| _ {raise Error "Lexer error"}

