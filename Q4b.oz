\insert 'Interpretor.oz'
declare
{ResetInterpretor}
Test1 = [
	    [ var ident(x)
	      [ var ident(y)
		[
		 [bind ident(x) [record literal(recordMe) [ [literal(myFirst) ident(y)] ]]]
		 [bind ident(y) [record literal(recordMe) [ [literal(myFirst) ident(x)] ]]]
		]
	      ]
	    ]
	   ]
declare
{ResetInterpretor}
Test2 = [
	    [ var ident(x1)
	      [ var ident(x)
		[ var ident(y)
		  [ var ident(y1)
		    [ [bind ident(x) [record literal(testRecord) [ [literal(onlyFeature) ident(x1)] ]]]
		      [bind ident(x1) literal(2)]
		      [bind ident(y) [record literal(testRecord) [ [literal(onlyFeature) ident(y1)] ]]]
		      [bind ident(y1) literal(2)]
		      [bind ident(x) ident(y)]
		    ]
		  ]
		]
	      ]
	    ]
	   ]


{Interpret {GetAST Test2}}