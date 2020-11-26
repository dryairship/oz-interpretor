\insert 'Interpretor.oz'

declare
{ResetInterpretor}
Test0 = [
	[ var ident(x)
	  [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
	]
]
{Interpret {GetAST Test0}}

declare
{ResetInterpretor}
Test1 = [
	    [ var ident(x)
	      [ var ident(y)
		[
		 [bind ident(x) [record literal(myrecord) [ [literal(first) ident(y)] ]]]
		 [bind ident(y) [record literal(myrecord) [ [literal(first) ident(x)] ]]]
		]
	      ]
	    ]
	   ]
{Interpret {GetAST Test1}}

declare
{ResetInterpretor}
Test2 = [
	    [ var ident(x1)
	    [ var ident(x)
		[ var ident(y)
		[ var ident(y1)
		    [ [bind ident(x) [record literal(myrecord) [ [literal(first) ident(x1)] ]]]
		      [bind ident(x1) literal(10)]
		      [bind ident(y) [record literal(myrecord) [ [literal(first) ident(y1)] ]]]
		      [bind ident(y1) literal(10)]
		      [bind ident(x) ident(y)]
		    ]
		]
		]
	    ]
	    ]
	]

{Interpret {GetAST Test2}}


% This is supposed to fail
declare
{ResetInterpretor}
Test3 = [
			[
				var ident(x) [
				var ident(y) [
					[bind ident(x) [record literal(myrecord) [literal(first) literal(foo)] [literal(second) literal(bar)]]]
					[bind ident(y) [record literal(myrecord) [literal(first) literal(bar)] [literal(second) literal(foo)]]]
					[bind ident(x) ident(y)]
				]
				]
			]
	    
	    ]
{Interpret {GetAST Test3}}
