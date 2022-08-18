
words = """ALNUM
ALPHA
BLANK
CNTRL
COLON
COMMA
COMMENT
DAY
DIGIT
DOLLAR
DOT
ESCAPESEQUENCE
GRAPH
GT
ID
INTEGER
LBRACE
LBRACK
LOWER
LPAREN
LT
MONTH
NL
OR
POWER
PRINT
PUNCT
RBRACE
RBRACK
RPAREN
SEMICOLON
SPACE
STAR
TIMEZONE
UNDERSCORE
UPPER
WS
XDIGIT"""

words = [x.strip() for x in words.splitlines()]

for WORD in words:
    code = f"""
    {{{WORD}}}+   {{
            if(yyleng==1){{
                    printf("{WORD}\\n");
            }} else {{
                    printf("{WORD}{{%d}}\\n",yyleng);
            }}
    }}"""
    print(code)