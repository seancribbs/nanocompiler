Nonterminals
  const prim1 binds expr program.

Terminals
  number add1 sub1 'let' in '=' '(' ')' ',' id.

Rootsymbol program.

program -> expr : '$1'.

expr -> 'let' binds 'in' expr : ?LET('$2', '$4').
expr -> prim1 '(' expr ')'    : ?PRIM1(unwrap('$1'), '$3').
expr -> const                 : '$1'.
expr -> id                    : ?ID(unwrap('$1')).

binds -> id '=' expr          : [{?TO_STR(unwrap('$1')), '$3'}].
binds -> id '=' expr ',' binds : [{?TO_STR(unwrap('$1')), '$3'}|'$5'].

prim1 -> add1 : '$1'.
prim1 -> sub1 : '$1'.

const -> number : ?NUMBER(unwrap('$1')).

Erlang code.

-define(LET(Binds, Expr),
        #{'__struct__' => 'Elixir.Nanocompiler.Let',
          binds => Binds,
          expr => Expr}).

-define(PRIM1(Op,Expr),
        #{'__struct__' => 'Elixir.Nanocompiler.Prim1',
          op => Op,
          expr => Expr}).

-define(ID(Name),
       #{'__struct__' => 'Elixir.Nanocompiler.ID',
         name => Name}).

-define(NUMBER(Int),
       #{'__struct__' => 'Elixir.Nanocompiler.Number',
         int => Int}).

-define(TO_STR(CharList),
        'Elixir.List':to_string(CharList)).

unwrap({_Kind, _Line, Value}) -> Value;
unwrap({Kind,  _Line})        -> Kind;
unwrap(Other) -> Other.
