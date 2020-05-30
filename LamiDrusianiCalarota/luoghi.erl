-module(luoghi).
-export([start/0, luogo/0]).


start() -> 
    io:format('Creo un luogo~n'),
    spawn(?MODULE, luogo, []).


luogo()->
	Server = global:whereis_name(server),
	link(Server),
	Server ! {new_place,self()},
	visita([]).

visita(Users)->
	receive
		{begin_visit,User,Ref} -> 
			io:format("inizio visita",[]),		
			contatto(User,Users),
		        chiudo(),	
			visita(Users++[{User, Ref}]);			
		{end_visit, User, Ref} -> 
			io:format("fine visita",[]),
			visita(Users--[{User, Ref}])
	end.

contatto(_, []) -> fine;
contatto(U1, [{U2,_}|U] ) -> 
		case rand:uniform(4) of
			1 -> U1 ! {contact, U2};
            _ -> ok
		end,
		contatto(U1,U).

chiudo() ->
    io:format("Entro in chiudo", []), 
	case rand:uniform(10) of
		1->io:format("Chiudo. Sono: ~p~n",[self()]),
		exit(normal);
        _ -> ok 
	end.	
