byte n = 0, finish;
bool wants_to_enter[2];
byte turn;

active proctype P0(){
    byte reg, counter = 0;  
    do
    :: (counter == 10) -> break;
    :: else ->
        wants_to_enter[0] = true;
        do
        :: wants_to_enter[1] ->
            if 
            :: (turn!=0) -> {
                wants_to_enter[0] = false;
                turn == 0;
                wants_to_enter[0] = true;  
            }
            :: else -> skip;
            fi
        :: else -> break;
        od
        /*start critical section*/
        reg = n;
        reg++;
        n = reg;
        /*end critical section*/
        turn = 1;
        wants_to_enter[0] = false;
        /*non-critical*/
        counter++;
    od
    finish++;
}

active proctype P1(){
    byte reg, counter = 0;
    do
    :: (counter == 10) -> break;
    :: else ->
        wants_to_enter[1] = true;
        do
        :: wants_to_enter[0] ->
            if
            :: (turn!=1) -> {
                wants_to_enter[1] = false;
                turn == 1;
                wants_to_enter[1] = true;
            }
            :: else -> skip;
            fi
        :: else -> break;
        od
        /*start critical section*/
        reg = n;
        reg++;
        n = reg;
        /*end critical section*/
        turn = 0;
        wants_to_enter[1] = false;
        /*non-critical*/
        counter++;
    od
    finish++;
}

/*propositions*/

#define done (finish==2)

/*LTL formula*/
ltl p { always (done implies n==20) }
