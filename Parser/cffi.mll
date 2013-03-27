rule lex= parse
| [' ' '\n' '\t' ] {lex lexbuf }
| ['#'] {Macro}
| [';' ] {End}
| ['0x']['0'-'9']+ as s {Int(int_of_string s)}
| []
