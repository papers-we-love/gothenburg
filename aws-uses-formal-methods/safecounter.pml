/*
- PROMELA program which verified the safety of Dekker's Algorithm
The two processes P0 and P1, loop 10 times each and increment a shared counter variable
- We try to verify that at no time during the execution, both processes are in the critical section of incrementing the counter
- This gaurantees a result of 20!
*/

byte n = 0;
bool wants_to_enter[2], in_critic[2], finish[2];
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
        in_critic[0] = true;
        reg = n;
        reg++;
        n = reg;
        in_critic[0] = false;
        /*end critical section*/
        turn = 1;
        wants_to_enter[0] = false;
        /*non-critical*/
        counter++;
    od
    finish[0]=true;
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
        in_critic[1] = true;
        reg = n;
        reg++;
        n = reg;
        in_critic[1] = false;
        /*end critical section*/
        turn = 0;
        wants_to_enter[1] = false;
        /*non-critical*/
        counter++;
    od
    finish[1]=true;
}

/* propositions */

#define done (finish[0] && finish[1])
#define nobody_wants_to (~(wants_to_enter[0] || wants_to_enter[1]))

//Used in Demo
//ltl completes {always (done implies nobody_wants_to)}

/* safety */
ltl safety {always (!(in_critic[0] && in_critic[1]))}
