%% Header

Definitions.

SIGNED_INT = (-)?([0-9])+
IDENT = [a-zA-z_]([a-zA-Z0-9_])*
WS = [\s\t\r\n]
ANY = .

Rules.

{WS}         : skip_token.
{SIGNED_INT} : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
add1         : {token, {add1, TokenLine}}.
sub1         : {token, {sub1, TokenLine}}.
let          : {token, {'let', TokenLine}}.
in           : {token, {'in', TokenLine}}.
=            : {token, {'=', TokenLine}}.
\(           : {token, {'(', TokenLine}}.
\)           : {token, {')', TokenLine}}.
,            : {token, {',', TokenLine}}.
{IDENT}      : {token, {id, TokenLine, TokenChars}}.
{ANY}        : {error, "Unrecognized character: " ++ TokenChars}.

Erlang code.
